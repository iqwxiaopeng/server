require "script.base"

citemdb = class("citemdb",cdatabaseable)

function citemdb:init(id)
	cdatabaseable.init(self,{
		id = id,
		flag = "citemdb",
	})
	self.data = {}
end

function citemdb:save()
	local data = {}
	data.data = data
	return data
end

function citemdb:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function citemdb:additem(item)

end

