require "script.base.class"
cobject = class("cobject")

print("oldid:",__id,cobject)
__id = __id or 0
print("newid:",__id)

function cobject:init(agent,fd,ip)
	__id = __id - 1
	self.id = __id
	self.__agent = agent
	self.__fd = fd
	self.__ip = ip
end
