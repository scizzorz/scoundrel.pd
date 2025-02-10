-- OOP
local Object = {}
Object.__index = Object

function Object:init()
end

-- constructor
function Object:__call(...)
  local instance = setmetatable({}, self)
  return instance, instance:init(...)
end

-- subclassing
function Object:subclass(namespace)
  namespace = namespace or {}
  namespace.__call = self.__call
  namespace.__index = namespace
  return setmetatable(namespace, self)
end

function Object:enrich(namespace)
  for k, v in pairs(namespace) do
    self[k] = v
  end
end

function Class(namespace)
  return Object:subclass(namespace)
end
