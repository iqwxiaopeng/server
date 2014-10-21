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
	self.__port = nil
	local pos = string.find(ip,":")
	if pos then
		self.__ip = ip:sub(1,pos-1)
		self.__port = ip:sub(pos+1)
	end
end
