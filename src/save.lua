-- playdate
local datastore <const> = playdate.datastore
local pd <const> = playdate

local function loadSave(path)
  local data = datastore.read(path) or {}
  data.version = tonumber(pd.metadata.buildNumber)
  data.win = data.win or 0
  data.lose = data.lose or 0
  data.time = data.time or 0
  return data
end

function readSave()
  SAVE = loadSave("data")
end

function writeSave()
  datastore.write(SAVE, "data", pd.isSimulator)
end
