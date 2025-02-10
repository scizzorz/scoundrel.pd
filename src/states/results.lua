-- std lib
local floor <const> = math.floor

-- playdate
local pd <const> = playdate
local gfx <const> = playdate.graphics

local TARGET_TITLE_Y = 3
local TARGET_PLAY_Y = 19
local TARGET_STAT_Y <const> = 24

Results = State {
  init = function(self, win, time)
    self.win = win
    if win then
      SAVE.win += 1
    else
      SAVE.lose += 1
    end
    SAVE.time += floor(time / 1000)

    self.statY = 32
    self.playY = 32
    self.titleY = -8

    writeSave()
  end,

  update = function(self, top)
    self.statY = lerp(self.statY, TARGET_STAT_Y, 0.5, 0.5)
    self.playY = lerp(self.playY, TARGET_PLAY_Y, 0.5, 0.5)
    self.titleY = lerp(self.titleY, TARGET_TITLE_Y, 0.5, 0.5)
  end,

  draw = function(self)
    gfx.clear()
    if self.win then
      Five:draw("h", 23, self.titleY)
    else
      Five:draw("m", 23, self.titleY)
    end

    Five:draw("a", 24, self.playY)
    Five:draw(SAVE.win .. "h", 1, self.statY)
    Five:drawRight(SAVE.lose .. "m", 49, self.statY)
  end,

  AButtonDown = function(self)
    Sound("sound/confirm"):play()
    replaceState(Transition, Play)
  end,

  BButtonDown = function(self)
    Sound("sound/cancel"):play()
    replaceState(Title, true)
  end,
}
