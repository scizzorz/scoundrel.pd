local t_insert <const> = table.insert
local t_remove <const> = table.remove
local t_shallowcopy <const> = table.shallowcopy
local t_unpack <const> = table.unpack

local nop <const> = function() end
local stateChangeQueue <const> = {}
local states <const> = {}

local state_metatable <const> = {
  __call = function(class, ...)
    local instance = setmetatable({}, class)
    return instance, instance:init(...)
  end,
}

-- return a new state class
function State(namespace)
  local class = {
    init = nop,

    -- lifecycle
    start = nop,
    finish = nop,
    update = nop,
    draw = nop,
    debugDraw = nop,
    pause = nop,
    resume = nop,

    -- system
    gameWillTerminate = nop,
    deviceWillLock = nop,
    deviceDidUnlock = nop,
    gameWillPause = nop,
    gameWillResume = nop,

    -- comms
    serialMessageReceived = nop,

    -- input
    cranked = nop,
    crankDocked = nop,
    crankUndocked = nop,

    AButtonDown = nop,
    BButtonDown = nop,
    AButtonUp = nop,
    BButtonUp = nop,
    AButtonHeld = nop,
    BButtonHeld = nop,
    upButtonDown = nop,
    downButtonDown = nop,
    rightButtonDown = nop,
    leftButtonDown = nop,
  }

  if namespace then
    t_shallowcopy(namespace, class)
  end

  -- we want `class` to be callable, so __call lives in its metatable but we
  -- want instances of `class` to index up to `class`, so self-indexing lives
  -- in it because `class` is the metatable of all instances.
  class.__index = class

  return setmetatable(class, state_metatable)
end

-- private functions that actually manipulate the stack
local function _pushState(_toState, ...)
  if #states > 0 then
    states[#states]:pause()
  end

  local newState = _toState(...)
  newState.parent = states[#states]
  table.insert(states, newState)
  newState:start()
end

local function _popState()
  local popped = t_remove(states)
  local nextTop = states[#states]
  popped:finish()
  if nextTop then
    nextTop:resume()
  end
end

local function _replaceState(_toState, ...)
  t_remove(states):finish()
  local newState = _toState(...)
  t_insert(states, newState)
  newState:start()
end

local function _popUntil(_dest)
  while states[#states] ~= _dest do
    _popState()
  end
end

-- basic stack inspection
function topState()
  return states[#states]
end

function numStates()
  return #states
end

function hasState(_state)
  for i = 1, #states do
    if states[i] == _state then
      return true
    end
  end
  return false
end

-- public functions that enqueue state changes
function pushState(...)
  t_insert(stateChangeQueue, {_pushState, ...})
end

function popState()
  t_insert(stateChangeQueue, {_popState})
end

function replaceState(...)
  t_insert(stateChangeQueue, {_replaceState, ...})
end

function popUntil(...)
  t_insert(stateChangeQueue, {_popUntil, ...})
end

-- should be called every frame
local call, fn
function updateStates()
  while #stateChangeQueue > 0 do
    call = t_remove(stateChangeQueue, 1)
    fn = t_remove(call, 1)
    fn(t_unpack(call))
  end

  for i = 1, #states do
    states[i]:update(i == #states)
  end
end

function drawStates()
  for i = 1, #states do
    states[i]:draw(i == #states)
  end
end

function debugDrawStates()
  for i = 1, #states do
    states[i]:debugDraw(i == #states)
  end
end
