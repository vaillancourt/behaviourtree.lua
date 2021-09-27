local _PACKAGE  = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class     = require(_PACKAGE..'/middleclass')
local Registry  = require(_PACKAGE..'/registry')
local Node      = class('Node')

function Node:initialize(config)
  print("Node:initialize() " .. (self.name or "?"))
  config = config or {}
  for k, v in pairs(config) do
    self[k] = v
  end

  if self.name ~= nil then
    Registry.register(self.name, self)
  end
end

function Node:start(object) 
  print("Node:start() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))
end

function Node:finish(object) 
  print("Node:finish() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))
  assert(object)
end

function Node:run(object) 
  print("Node:run() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))
end

function Node:call_run(object)
  print("Node:call_run() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))
  success = function() self:success() end
  fail = function()    self:fail() end
  running = function() self:running() end
  self:run(object)
  success, fail, running = nil,nil,nil
end

function Node:setObject(object)
  print("Node:setObject() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))
  self.object = object
end

function Node:setControl(control)
  print("Node:setControl() " .. self.name)
  self.control = control
end

function Node:running()
  print("Node:running() " .. self.name)
  if self.control then
    self.control:running(self)
  end
end

function Node:success()
  print("Node:success() " .. self.name)
  if self.control then
    self.control:success()
  end
end

function Node:fail()
  print("Node:fail() " .. self.name)
  if self.control then
    self.control:fail()
  end
end

return Node
