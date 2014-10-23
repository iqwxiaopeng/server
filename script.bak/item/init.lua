require "script.base"

citem = class("item",cdatabaseable)

function citem:init(id)
	cdatabaseable.init(self,{
		id = id,
		flag = "item",
	})
	self.data = {}
end

function citem:save()
	local data = {}
	data.data = self.data
	return data
end

function citem:load(data)
	if not data then
		return
	end
	self.data = data.data
end


