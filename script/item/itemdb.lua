require "script.base"

citemdb = class("citemdb",cdatabaseable)

function citemdb:init(pid)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "citemdb",
	})
	self.data = {}
	self.id_item = {}
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

