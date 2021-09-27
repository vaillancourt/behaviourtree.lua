local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local BranchNode = class('BranchNode', Node)

function BranchNode:start(object)
  print("BranchNode:start() " .. self.name .. " isObject=" .. ((object and "yes") or "no") .. " actualTask=" .. (self.actualTask or "nil"))
  print("--> " .. ((self.nodeRunning and "nodeRunning") or "not nodeRunning"))
  if not self.nodeRunning then
    self:setObject(object)
    self.actualTask = 1
  end
end

function BranchNode:run(object)
  print("BranchNode:run() " .. self.name .. " isObject=" .. ((object and "yes") or "no") .. " actualTask=" .. self.actualTask)
  if self.actualTask <= #self.nodes then
    self:_run(object)
  end
end

function BranchNode:_run(object)
  print("BranchNode:_run() " .. self.name .. " isObject=" .. ((object and "yes") or "no") .. " actualTask=" .. self.actualTask)
  print("--> " .. ((self.nodeRunning and "nodeRunning") or "not nodeRunning"))

  if not self.nodeRunning then
    print("--> if not self.nodeRunning then")
    self.node = Registry.getNode(self.nodes[self.actualTask]) 
    assert(object)
    self.node:start(object)
    self.node:setControl(self)
  end
  self.node:run(object)
end

function BranchNode:running()
  print("BranchNode:running() " .. self.name)
  print("--> nodeRunning set to true")

  if not self.node then
    assert(false)
  end
  self.nodeRunning = true
  self.control:running()
end

function BranchNode:success()
  print("BranchNode:success() " .. self.name)
  print("--> nodeRunning set to false")

  self.nodeRunning = false
  self.node:finish(self.object)
  self.node = nil
  if self.name == "movingSequence" then
    if not self.myFlag then
      self.myFlag = 1
    else
      self.myFlag = self.myFlag + 1
    end
    print("--> myFlag " .. self.myFlag)
  end
end

function BranchNode:fail()
  print("BranchNode:fail() " .. self.name)
  print("--> nodeRunning set to false")

  self.nodeRunning = false
  self.node:finish(self.object);
  self.node = nil
end

return BranchNode
