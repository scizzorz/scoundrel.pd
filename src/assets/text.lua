-- playdate
local gfx <const> = playdate.graphics

local FONT_CACHE <const> = {}
function Font(path)
  local ret = FONT_CACHE[path]
  if not ret then
    if SHOW_CACHE_MISSES then
      debug("Font cache miss: %s", path)
    end
    local font = gfx.font.new(path)
    assert(font, "failed to load font at " .. path)

    local CACHE <const> = {}
    local function getText(text)
      if not text or #text == 0 then
        return
      end

      local image = CACHE[text]
      if not image then
        if SHOW_CACHE_MISSES then
          debug("Text cache miss: %s", text)
        end
        image = gfx.imageWithText(text, 400, 32, nil, nil, nil, nil, font)
        assert(image, string.format("failed to generate image for text '%s'", text))
        CACHE[text] = image
      end
      return image
    end

    ret = {
      get = function(self, text)
        -- some magic to allow . calls in addition to : calls
        return getText(text or self)
      end,

      draw = function(self, text, x, y)
        local image = getText(text)
        local w, h = image:getSize()
        image:draw(x, y)
        return w, h
      end,

      drawRight = function(self, text, x, y)
        local image = getText(text)
        local w, h = image:getSize()
        image:draw(x - w, y)
        return w, h
      end,

      drawCenter = function(self, text, x, y)
        local image = getText(text)
        local w, h = image:getSize()
        image:draw(x - w / 2, y)
        return w, h
      end,

      getSize = function(self, text)
        return getText(text):getSize()
      end,
    }
    FONT_CACHE[path] = ret
  end

  return ret
end
