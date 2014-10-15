require "base.class"
cobject = class("cobject")

__id = __id or 0

function cobject:init(agent)
	__id = __id - 1
	self.id = id
	self.__agent = agent
end
