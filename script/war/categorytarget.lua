require "script.base"
require "script.war.aux"

ccategorytarget = class("ccategorytarget")

function ccategorytarget:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.id_obj = {}
	self.halos = {}
	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
	self.onadd = {}
	self.ondel = {}
end

function ccategorytarget:addobj(obj)
	local id = obj.warcardid
	assert(self.id_obj[id] == nil,"Repeat warcardid:" .. tostring(id))
	self.id_obj[id] = obj
	self:__onadd(obj)
end

function ccategorytarget:delobj(id)
	local obj = self.id_obj[id]
	if obj then
		self:__ondel(obj)
		self.id_obj[id] = nil
	end
end

function ccategorytarget:addbuff(value,srcid)
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addbuff(value,srcid)
		end
	end
end

function ccategorytarget:delbuff(srcid)
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:delbuff(srcid)
		end
	end
end

function ccategorytarget:addhalo(value,srcid)
	table.insert(self.halos,{srcid=srcid,value=value})
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addhalo(value,srcid)
		end
	end
end

function ccategorytarget:delhalo(srcid)
	local found = false
	for i,v in ipairs(self.halos) do
		if v.srcid == srcid then
			found = table.remove(self.halos,i)
			break
		end
	end
	if found then
		for warcardid,warcard in pairs(self.id_obj) do
			if warcardid ~= srcid then
				warcard:delhalo(srcid)
			end
		end
	end
end

function ccategorytarget:gethurtorder()
	-- need modify
	return values(self.id_obj)
end

function ccategorytarget:allid()
	return keys(self.id_obj)
end

function ccategorytarget:addhp(value,srcid)
	local objs = self:gethurtorder()
	for i,obj in ipairs(objs) do
		obj:addhp(value,srcid)
	end
end

function ccategorytarget:setstate(type,value)
	for id,warcard in pairs(self.id_obj) do
		warcard:setstate(type,value)
	end
end


function ccategorytarget:__onadd(warcard)
	for i,v in ipairs(self.halos) do
		warcard:addhalo(v.value,v.srcid)
	end
	local ret = false
	local ignoreevent = IGNORE_NONE
	local warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onadd) do
		warcard = warobj.id_card[v]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__onadd(warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function ccategorytarget:__ondel(warcard)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondel) do
		warcard = warobj.id_card[v]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__ondel(warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

return ccategorytarget
