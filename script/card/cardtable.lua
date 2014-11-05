require "script.base"

ccardtablelib = class("ccardtablelib",cdatabaseable)

function ccardtablelib:init(pid)
	self.flag = "ccardtablelib"	
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.data = {}
	self.normal_cardtablelib = {}
	self.nolimit_cardtablelib = {}
end

function ccardtablelib:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
end

function ccardtablelib:save()
	local data = {}
	data.data = self.data
	return data
end


function ccardtablelib:update_cardtable(cardtable)
	local id = cardtable.id
	assert(1 <= id and id <= 8,"Invalid cardtable id:" .. tostring(id))
	local mode = cardtable.mode
	if mode == 0 then
		self.normal_cardtablelib[id] = cardtable
	else
		self.nolimit_cardtablelib[id] = cardtable
	end
end

function ccardtablelib:delcardtable(cardtable)
	local id = cardtable.id
	assert(1 <= id and id <= 8,"Invalid cardtable id:" .. tostring(id))
	local mode = cardtable.mode
	if mode == 0 then
		self.normal_cardtablelib[id] = nil
	else
		self.nolimit_cardtablelib[id] = cardtable
	end
end

return ccardtablelib
