require "script.base"

cattrcontainer = class("cattrcontainer")

function cattrcontainer:init(args)
	self.data = {}
	for attrname,attr in pairs(args) do
		self.data[attrname] = attr
	end
end

function cattrcontainer:load(data)
	if not data then
		return
	end
	for attrname,attrdata in pairs(data) do
		if not self.data[attrname] then
			error(string.format("[cattrcontainer:load] attrname not exists, attrname=%s",attrname))
		end
		self.data[attrname]:load(attrdata)
	end
end

function cattrcontainer:save()
	local data = {}
	for attrname,attr in pairs(self.data) do
		data[attrname] = attr:save()
	end
	return data
end
