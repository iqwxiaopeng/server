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

function ccategorytarget:gethurtorder()
	-- need modify
	return values(self.id_obj)
end

function ccategorytarget:addhp(value,srcid)
	local objs = self:gethurtorder()
	for i,obj in ipairs(objs) do
		obj:addhp(value,srcid)
	end
end


function ccategorytarget:__onadd(warcard)
	for i,v in ipairs(self.halos) do
		warcard:addhalo(v.value,v.srcid)
	end
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onadd) do
		local owner = war:getowner(id)
		local warcard = owner.id_card[id]
		local cardcls = getclassbysid(warcard.sid)
		cardcls.__onadd(warcard)
	end
end

function ccategorytarget:__ondel(warcard)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.ondel) do
		local owner = war:getowner(id)
		local warcard = owner.id_card[id]
		local cardcls = getclassbysid(warcard.sid)
		cardcls.__ondel(warcard)
	end
end

function ccategorytarget:remove_effect(srcid)
	local del_halos = {}
	for i,effect in ipairs(self.halos) do
		if effect.srcid == srcid then
			table.insert(del_halos,1,i)
		end
	end
	for i,pos in ipairs(del_halos) do
		table.remove(self.halos,pos)
	end
	for id,obj in pairs(self.id_obj) do
		obj:remove_effect(srcid)
	end
end

function ccategorytarget:register(type,warcardid)
	return register(self,type,warcardid)
end

function ccategorytarget:unregister(type,warcardid)
	return unregister(self,type,warcardid)
end

return ccategorytarget
