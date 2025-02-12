-- playdate
local snd <const> = playdate.sound

local SOUND_CACHE <const> = {}
function Sound(path)
  if not path then
    return
  end

  local ret = SOUND_CACHE[path]
  if not ret then
    if SHOW_CACHE_MISSES then
      debug("Sound cache miss: %s", path)
    end
    local sound = snd.sampleplayer.new(path)
    assert(sound, "failed to load sound at " .. path)
    ret = {
      play=function()
        sound:stop()
        sound:play(1)
      end,

      stop = function()
        sound:stop()
      end,
    }
    SOUND_CACHE[path] = ret
  end

  return ret
end
