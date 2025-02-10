local abs <const> = math.abs
local fmt <const> = string.format

local CRANK_NOTCH <const> = 360 / 6
local crankAcc = 0
function standardCranked(_state, _change)
  crankAcc += _change
  while crankAcc >= CRANK_NOTCH / 2 do
    crankAcc -= CRANK_NOTCH
    _state:crankUp()
  end

  while crankAcc <= -CRANK_NOTCH / 2 do
    crankAcc += CRANK_NOTCH
    _state:crankDown()
  end
end

function lerp(_from, _to, _speed, _tolerance)
  _from += (_to - _from) * (_speed or 0.2)
  if abs(_from - _to) <= (_tolerance or 0.01) then
    _from = _to
  end
  return _from
end

function debug(...)
  print(fmt(...))
end
