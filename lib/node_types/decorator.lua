local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local Decorator = class('Decorator', Node)

function Decorator:initialize(config)
  print("Decorator:initialize() " .. (self.name or "?"))
  Node.initialize(self, config)
  self.node = Registry.getNode(self.node)
end

function Decorator:setNode(node)
  print("Decorator:setNode() " .. self.name)
  self.node = Registry.getNode(node)
end

function Decorator:start(object)
  print("Decorator:start" .. self.name)
  self.node:start(object)
end

function Decorator:finish(object)
  print("Decorator:finish" .. self.name)
  self.node:finish(object)
end

function Decorator:run(object)
  print("Decorator:run() " .. self.name)
  self.node:setControl(self)
  self.node:call_run(object)
end

return Decorator
