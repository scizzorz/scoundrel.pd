playdate.resetElapsedTime()
print("Initialization started") -- debug isn't loaded yet
DEMO = false
RELEASE = false
SHOW_CACHE_MISSES = true

-- playdate
import("CoreLibs/graphics")

-- engine
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
playdate.display.setScale(8)
readSave()
pushState(Title)
Five = Font("font/five")
debug("Setup ended after %.3fms", playdate.getElapsedTime() * 1000)
