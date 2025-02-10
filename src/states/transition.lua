-- std lib
local t_unpack <const> = table.unpack

-- playdate
local gfx <const> = playdate.graphics

-- graphics
local black <const> = gfx.kColorBlack
local white <const> = gfx.kColorWhite

Transition = State {
  init = function(self, toState, ...)
    self.fromImage = gfx.getDisplayImage()
    self.toState = toState
    self.args = {...}
    self.frame = 0
  end,

  start = function(self)
    self.fill = 0
    self.tfill = 1
    self.exit = false
  end,

  update = function(self)
    self.frame += 1

    if self.fill == self.tfill  then
      replaceState(self.toState, t_unpack(self.args))
    else
      self.fill = lerp(self.fill, self.tfill, 0.3, 0.03)
    end
  end,

  draw = function(self)
    gfx.clear()
    self.fromImage:draw(0, 0)
    gfx.setStencilPattern(self.fill)
    gfx.setColor(white)
    gfx.fillRect(0, 0, 400, 240)
    gfx.clearStencil()
  end,
}
