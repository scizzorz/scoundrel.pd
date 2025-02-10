-- std lib
local floor <const> = math.floor
local t_insert <const> = table.insert

-- playdate
local pd <const> = playdate
local gfx <const> = playdate.graphics

-- graphics
local black <const> = gfx.kColorBlack
local white <const> = gfx.kColorWhite

-- engine
local lerp <const> = lerp

local RANK_MAP = {
  "a",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "x",
  "j",
  "q",
  "k",
}

local CARD_COORDS = {
  {19, 10}, -- up
  {33, 15}, -- right
  {19, 20}, -- down
  {5, 15}, -- left
}

local TARGET_HP_X <const> = 14
local TARGET_REM_X <const> = 13
local TARGET_KEY_Y <const> = 3

-- main state
Play = State {
  start = function(self)
    self.hpX = -100
    self.remX = -200
    self.keyY = -10
    self.cardOffsetY = {100, 200, 300, 400}
    self.shadowCards = {}

    self.game = Game(function(...) self:event(...) end)
    self.game:draw()
    self.startTime = pd.getCurrentTimeMilliseconds()
  end,

  update = function(self)
    self.hpX = lerp(self.hpX, TARGET_HP_X, 0.5, 0.5)
    self.remX = lerp(self.remX, TARGET_REM_X, 0.5, 0.5)
    self.keyY = lerp(self.keyY, TARGET_KEY_Y, 0.5, 0.5)
    for index = 1, 4 do
      self.cardOffsetY[index] = lerp(self.cardOffsetY[index], 0, 0.5, 0.5)
    end
  end,

  draw = function(self)
    gfx.clear()
    gfx.setColor(black)

    if not self.game.consecutiveRun and self.game:count() == 4 then
      Five:draw("r", 24, self.keyY)
    end

    if self.game.shield then
      Five:drawRight(RANK_MAP[self.game.shield] .. "s", 49, 1)
      if self.game.dur then
        Five:drawRight(RANK_MAP[self.game.dur] .. "m", 49, 9)
      end
    end

    Five:drawRight(self.game.hp .. "h", self.hpX, 1)
    Five:drawRight(#self.game.deck .. "c", self.remX, 7)

    for shadowIndex = 1, #self.shadowCards do
      local info = self.shadowCards[shadowIndex]
      info.fill = lerp(info.fill, 0, 0.3, 0.03)

      local card = info.card
      local x, y = table.unpack(CARD_COORDS[info.index])
      gfx.setStencilPattern(info.fill)
      gfx.setColor(white)
      gfx.fillRect(x, y, 13, 9)
      gfx.setColor(black)
      gfx.drawRect(x, y, 13, 9)
      Five:draw(RANK_MAP[card.rank] .. card.suit, x + 2, y + 2)
      gfx.clearStencil()
    end

    for index = 1, 4 do
      local card = self.game.room[index]
      local x, y = table.unpack(CARD_COORDS[index])
      local offsetY = floor(self.cardOffsetY[index])
      if card then
        gfx.setColor(white)
        gfx.fillRect(x, y + offsetY, 13, 9)
        gfx.setColor(black)
        gfx.drawRect(x, y + offsetY, 13, 9)
        Five:draw(RANK_MAP[card.rank] .. card.suit, x + 2, y + offsetY + 2)
      end
    end

    for index = 1, 4 do
      local card = self.game.room[index]
      local x, y = table.unpack(CARD_COORDS[index])
      local offsetY = floor(self.cardOffsetY[index])
      if not card then
        -- because of the particular alignment of cards within the standard 0.5
        -- checkerboard pattern, the top/bottom cards need to have the inverted
        -- checkerboard pattern.
        if (index % 2) == 1 then
          gfx.setStencilPattern({0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA})
        else
          gfx.setStencilPattern(0.5)
        end
        gfx.drawRect(x, y + offsetY, 13, 9)
        gfx.clearStencil()
      end
    end
  end,

  gameWillPause = function(self)
    local menu = pd.getSystemMenu()
    menu:removeAllMenuItems()
    menu:addMenuItem("forfeit", function()
      local endTime = pd.getCurrentTimeMilliseconds()
      replaceState(Transition, Results, false, endTime - self.startTime)
    end)
  end,

  AButtonDown = function(self)
    self:checkDone()
  end,

  BButtonDown = function(self)
    self.game:run()
    self:checkDone()
  end,

  upButtonDown = function(self)
    self.game:pick(1)
    self:checkDone()
  end,

  rightButtonDown = function(self)
    self.game:pick(2)
    self:checkDone()
  end,

  downButtonDown = function(self)
    self.game:pick(3)
    self:checkDone()
  end,

  leftButtonDown = function(self)
    self.game:pick(4)
    self:checkDone()
  end,

  checkDone = function(self)
    if self.game:done() then
      local endTime = pd.getCurrentTimeMilliseconds()
      replaceState(Transition, Results, not self.game:loss(), endTime - self.startTime)
      return
    end
  end,

  event = function(self, event, ...)
    if event == "draw" then
      local index, card = ...
      self.cardOffsetY[index] = index * 200
      Sound("sound/draw"):play()
    elseif event == "play" or event == "discard" then
      local index, card = ...
      t_insert(self.shadowCards, {index=index, card=card, fill=1})
      if event == "play" then
        Sound("sound/play"):play()
      elseif event == "discard" then
        Sound("sound/discard"):play()
      end
    elseif event == "run" then
      Sound("sound/run"):play()
    else
      debug("unhandled event: %s", event)
    end
  end,
}
