import "CoreLibs/graphics"
import "CoreLibs/timer"

import "states"

local fmt <const> = string.format

local pd_resetElapsedTime <const> = playdate.resetElapsedTime
local pd_getElapsedTime <const> = playdate.getElapsedTime
local pd_getRefreshRate <const> = playdate.display.getRefreshRate
local pd_timer_updateTimers <const> = playdate.timer.updateTimers

local droppedFrame = false

-- system callbacks
function playdate.update()
  pd_timer_updateTimers()
  local frameLimit = 1 / pd_getRefreshRate()
  pd_resetElapsedTime()

  droppedFrame = false

  updateStates()
  drawStates()

  local done = pd_getElapsedTime()
  droppedFrame = done > frameLimit or droppedFrame

  if droppedFrame and not RELEASE then
    print(fmt("frame: %.3fms", done * 1000))
  end
end

function playdate.debugDraw()
  debugDrawStates()
end

function playdate.gameWillTerminate()
  local top = topState()
  if top then top:gameWillTerminate() end
end

function playdate.deviceWillLock()
  local top = topState()
  if top then top:deviceWillLock() end
end

function playdate.deviceDidUnlock()
  local top = topState()
  if top then top:deviceDidUnlock() end
end

function playdate.gameWillPause()
  local top = topState()
  if top then top:gameWillPause() end
end

function playdate.gameWillResume()
  local top = topState()
  if top then top:gameWillResume() end
end

function playdate.cranked(_change, _acceleratedChange)
  local top = topState()
  if top then top:cranked(_change, _acceleratedChange) end
end

function playdate.crankDocked()
  local top = topState()
  if top then top:crankDocked() end
end

function playdate.crankUndocked()
  local top = topState()
  if top then top:crankUndocked() end
end

function playdate.AButtonDown()
  local top = topState()
  if top then top:AButtonDown() end
end

function playdate.AButtonUp()
  local top = topState()
  if top then top:AButtonUp() end
end

function playdate.BButtonDown()
  local top = topState()
  if top then top:BButtonDown() end
end

function playdate.BButtonUp()
  local top = topState()
  if top then top:BButtonUp() end
end

function playdate.upButtonDown()
  local top = topState()
  if top then top:upButtonDown() end
end

function playdate.downButtonDown()
  local top = topState()
  if top then top:downButtonDown() end
end

function playdate.rightButtonDown()
  local top = topState()
  if top then top:rightButtonDown() end
end

function playdate.leftButtonDown()
  local top = topState()
  if top then top:leftButtonDown() end
end

function playdate.AButtonHeld()
  local top = topState()
  if top then top:AButtonHeld() end
end

function playdate.BButtonHeld()
  local top = topState()
  if top then top:BButtonHeld() end
end

function playdate.serialMessageReceived(_message)
  local top = topState()
  if top then top:serialMessageReceived(_message) end
end
