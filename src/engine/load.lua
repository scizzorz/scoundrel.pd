-- std lib
local t_insert <const> = table.insert
local t_remove <const> = table.remove
local t_unpack <const> = table.unpack

-- playdate
local pd <const> = playdate

function Loader(bandwidth)
  local frame = 0
  local size = 0
  local calls = {}
  return {
    done = function(self)
      return #calls == 0
    end,

    count = function(self)
      return #calls
    end,

    size = function(self)
      return size
    end,

    add = function(self, call)
      size += 1
      t_insert(calls, call)
      return self
    end,

    process = function(self)
      if #calls == 0 then
        return
      end

      frame += 1
      local amount = 0
      local call, func
      local realStart = pd.getElapsedTime()

      -- generally, bandwidth should be around 10ms smaller than the target
      -- frame timer. we only know how much time is left at the start of
      -- loading an asset, but we don't always know how long loading that asset
      -- will take. so the 10ms headroom is to account for some of the longer
      -- assets while still leaving room for the frame limiter to be happy.
      --
      -- this is a repeat loop to ensure it runs at least once per frame, but
      -- that may not be ideal in some cases and can be changed to a while
      -- instead.
      repeat
        local call = t_remove(calls, 1)
        local func = t_remove(call, 1)
        func(t_unpack(call))
        amount += 1
      until #calls == 0 or pd.getElapsedTime() >= bandwidth

      if #calls == 0 then
        debug("Precached %d assets after %d frames | %.0fms", size, frame, pd.getCurrentTimeMilliseconds())
      end
    end,
  }
end
