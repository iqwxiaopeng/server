require "script.base"
require "script.war.aux"

ccategorytarget = class("ccategorytarget")

function ccategorytarget:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.id_obj = {}
	self.bufs = {}
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

function ccategorytarget:addbuf(value,srcid)
	table.insert(self.bufs,{srcid=srcid,value=value,})
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addbuf(value,srcid)
		end
	end
end

function ccategorytarget:delbuf(srcid)
	local delbufs = {}
	for i,v in ipairs(self.bufs) do
		if v.srcid == srcid then
			table.insert(delbufs,i)
		end
	end
	for _,pos in ipairs(delbufs) do
		table.remove(self.bufs,pos)
	end
	if #delbufs > 0 then
		for warcardid,warcard in pairs(self.id_obj) do
			warcard:delbuf(srcid)
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

function ccategorytarget:sethp(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:sethp(value,srcid)
	end
end

function ccategorytarget:addatk(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:addatk(value,srcid)
	end
end

function ccategorytarget:setatk(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:setatk(value,srcid)
	end
end

function ccategorytarget:addcrystalcost(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:addcrystalcost(value,srcid)
	end
end

function ccategorytarget:setcrystalcost(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:setcrystalcost(value,srcid)
	end
end

function ccategorytarget:__onadd(warcard)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onadd) do
		parseeffect(self,v.srcid,v.action,warcard)
	end
end

function ccategorytarget:__ondel(warcard)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondel) do
		parseeffect(self,v.srcid,v.action,warcard)
	end
end

function ccategorytarget:remove_effect(srcid)
	local del_halos = {}
	for i,effect in ipairs(self.halos) do
		if effect.srcid == srcid then
			table.insert(del_halos,i)
		end
	end
	for i,pos in ipairs(del_halos) do
		table.remove(self.halos,pos)
	end
	for id,obj in pairs(self.id_obj) do
		obj:remove_effect(srcid)
	end
end


return ccategorytarget
