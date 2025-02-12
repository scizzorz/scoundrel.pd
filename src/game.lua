-- std lib
local max <const> = math.max
local min <const> = math.min
local random <const> = math.random
local t_insert <const> = table.insert
local t_remove <const> = table.remove

function shuffle(tab)
  for index = #tab, 2, -1 do
    local swapWith = random(index)
    tab[index], tab[swapWith] = tab[swapWith], tab[index]
  end
end

Game = Class {
  init = function(self, event)
    self.event = event

    local deck <const> = {}
    for rank = 1, 13 do
      t_insert(deck, {suit="m", rank=rank})
      t_insert(deck, {suit="m", rank=rank})
    end
    for rank = 2, 10 do
      t_insert(deck, {suit="h", rank=rank})
      t_insert(deck, {suit="s", rank=rank})
    end

    self.hp = 20
    self.consecutiveRun = false
    self.consecutivePotion = false
    self.shield = nil
    self.dur = nil
    self.deck = deck
    self.room = {}
  end,

  -- win and loss conditions are not exclusive! the loss condition should be
  -- checked before the win condition in order to avoid false victories.
  win = function(self)
    return #self.deck == 0 and self:count() == 0
  end,

  loss = function(self)
    return self.hp <= 0
  end,

  done = function(self)
    return self:win() or self:loss()
  end,

  draw = function(self)
    self.consecutivePotion = false

    for index = 1, 4 do
      if not self.room[index] and #self.deck > 0 then
        local card = t_remove(self.deck, random(#self.deck))
        self.room[index] = card
        self.event("draw", index, card)
      end
    end
  end,

  count = function(self)
    local count = 0
    for index = 1, 4 do
      if self.room[index] then
        count += 1
      end
    end

    return count
  end,

  run = function(self)
    if self.consecutiveRun then
      return false
    end

    if self:count() < 4 then
      return false
    end

    self.event("run")

    self.consecutiveRun = true
    for index = 1, 4 do
      local card = self.room[index]
      if card then
        t_insert(self.deck, card)
        self.room[index] = nil
        self.event("discard", index, card)
      end
    end

    self:draw()
  end,

  pick = function(self, index)
    if not self.room[index] then
      return false
    end

    self.consecutiveRun = false

    local card = self.room[index]
    if card.suit == "h" then
      if not self.consecutivePotion then
        self.hp = min(20, self.hp + card.rank)
        self.consecutivePotion = true
      end
    elseif card.suit == "s" then
      self.shield = card.rank
      self.dur = nil
    else
      local damage = card.rank
      if self.shield then
        if not self.dur then
          self.dur = damage
          damage -= self.shield
        elseif damage <= self.dur then
          self.dur = damage
          damage -= self.shield
        end
      end

      self.hp -= max(damage, 0)
    end

    self.room[index] = nil
    self.event("play", index, card)

    if self:count() <= 1 then
      self:draw()
    end
  end,
}
