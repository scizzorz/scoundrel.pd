-- playdate
local gfx <const> = playdate.graphics
local pd <const> = playdate

local TARGET_TITLE_Y = 3
local TARGET_PLAY_Y = 19
local TARGET_STAT_Y <const> = 24

Title = State {
  init = function(self, skipTransition)
    if skipTransition then
      self.statY = TARGET_STAT_Y
      self.titleY = TARGET_TITLE_Y
      self.playY = TARGET_PLAY_Y
    else
      self.statY = 32
      self.playY = 32
      self.titleY = -8
    end
  end,

  update = function(self, top)
    self.statY = lerp(self.statY, TARGET_STAT_Y, 0.5, 0.5)
    self.playY = lerp(self.playY, TARGET_PLAY_Y, 0.5, 0.5)
    self.titleY = lerp(self.titleY, TARGET_TITLE_Y, 0.5, 0.5)
  end,

  draw = function(self)
    gfx.clear()
    Five:draw("hms", 17, self.titleY)
    Five:draw("a", 24, self.playY)
    Five:draw(SAVE.win .. "h", 1, self.statY)
    Five:drawRight(SAVE.lose .. "m", 49, self.statY)
  end,

  AButtonDown = function(self)
    Sound("sound/confirm"):play()
    replaceState(Transition, Play)
  end,
}
