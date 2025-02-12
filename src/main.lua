playdate.resetElapsedTime()
print("Initialization started") -- debug isn't loaded yet
DEMO = false
RELEASE = false
SHOW_CACHE_MISSES = true

-- playdate
import("CoreLibs/graphics")

-- engine
import("engine/load")
import("engine/object")
import("engine/states")
import("engine/system")
import("engine/utils")

-- assets
import("assets/text")
import("assets/sound")

-- goodies
import("game")
import("save")

-- states
import("states/play")
import("states/results")
import("states/title")
import("states/transition")

-- setup
debug("Initialization ended after %.3fms", playdate.getElapsedTime() * 1000)
playdate.resetElapsedTime()

-- assets
Five = Font("font/five")
Precache = Loader(0.020)
  :add {Sound, "sound/cancel"}
  :add {Sound, "sound/confirm"}
  :add {Sound, "sound/discard"}
  :add {Sound, "sound/draw"}
  :add {Sound, "sound/play"}
  :add {Sound, "sound/run"}
  :add {Five.get, "hms"} -- title text
  :add {Five.get, "a"} -- A button
  :add {Five.get, "m"} -- monster (loss)
  :add {Five.get, "h"} -- heart (win)
  :add {Five.get, "r"} -- key
  :add {Five.get, "xh"} -- 10 of hearts
  :add {Five.get, "xm"} -- 10 of monsters
  :add {Five.get, "xs"} -- 10 of shields
  :add {Five.get, "am"} -- ace of monsters
  :add {Five.get, "jm"} -- jack of monsters
  :add {Five.get, "qm"} -- queen of monsters
  :add {Five.get, "km"} -- king of monsters (godzilla!)

-- some of these aren't used. oh well
for rank = 1, 10 do
  Precache:add {Five.get, rank .. "h"} -- hearts
  Precache:add {Five.get, rank .. "m"} -- monsters
  Precache:add {Five.get, rank .. "s"} -- shields
  Precache:add {Five.get, rank .. "c"} -- cards remaining
end

for rank = 11, 20 do
  Precache:add {Five.get, rank .. "h"} -- health
  Precache:add {Five.get, rank .. "c"} -- cards remaining
end

for rank = 21, 40 do
  Precache:add {Five.get, rank .. "c"} -- cards remaining
end

-- start game
playdate.display.setScale(8)
readSave()
pushState(Title)

debug("Setup ended after %.3fms", playdate.getElapsedTime() * 1000)
