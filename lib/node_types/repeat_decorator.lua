local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Decorator  = require(_PACKAGE..'/node_types/decorator')
local RepeatDecorator = class('RepeatDecorator', Decorator)


function RepeatDecorator:start(object)
  print("RepeatDecorator:start() " .. self.name .. " isObject=" .. ((object and "yes") or "no"))

  self:setObject(object)
  Decorator.start(self, object)
end

function RepeatDecorator:success()
  print("RepeatDecorator:success() " .. self.name)

  self.node:finish(self.object)
  self.node:start(self.object)

  self.control:running()
end

function RepeatDecorator:fail()
  print("RepeatDecorator:fail() " .. self.name)

  self.control:success()
end

return RepeatDecorator
