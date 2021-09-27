local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Decorator  = require(_PACKAGE..'/node_types/decorator')
local RepeatDecorator = class('RepeatDecorator', Decorator)


function RepeatDecorator:start(object)
  self:setObject(object)
  Decorator.start(self, object)
end

function RepeatDecorator:success()
  self.node:finish(self.object)
  self.node:start(self.object)

  self.control:running()
end

function RepeatDecorator:fail()
  self.control:success()
end

return RepeatDecorator
