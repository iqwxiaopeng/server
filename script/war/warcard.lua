require "script.base"
require "script.card.aux"
require "script.war.aux"

local BUFF_TYPE = 0
local HALO_TYPE = 1

cwarcard = class("cwarcard")

function cwarcard:init(conf)
	self.id = assert(conf.id)
	self.sid = assert(conf.sid)
	self.warid = assert(conf.warid)
	self.pid = assert(conf.pid)
	self.pos = nil
	self.inarea = "cardlib"
	self.halos = {}
	self.buffs = {}
	self.buff = {}
	self.state = {}
	self.influence_target = {} -- 站场效果施加到的若干目标

	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
	self.onenrage = {}
	self.onunenrage = {}
	self.events = {
		onhurt = true,
		ondie = true,
		ondefense = true,
		onattack = true,
		onenrage = true,
		onunenrage = true,
	}
	self:initproperty()
end

function cwarcard:initproperty()
	local cardcls = getclassbycardsid(self.sid)
	self.type =  cardcls.type
	self.maxhp = cardcls.hp
	self.hp = self.maxhp
	self.atk = cardcls.atk
	self.crystalcost = cardcls.crystalcost
end

local valid_buff = {
	addmaxhp = true,
	addatk = true,
	addcrystalcost = true,
	setatk = true,
	setmaxhp = true,
	setcrystalcost = true,
	mincrystalcost = true,
}

local valid_halo = {
	addmaxhp = true,
	addatk = true,
	addcrystalcost = true,
	setatk = true,
	setmaxhp = true,
	setcrystalcost = true,
	mincrystalcost = true,
}

function cwarcard:addbuff(value,srcid)
	table.insert(self.buffs,{srcid=srcid,value=value})
	for k,v in pairs(value) do
		if valid_buff[k] then
			local func = self[k]
			func(self,v,srcid,BUFF_TYPE)
		end
	end
end

function cwarcard:delbuff(value)
	for k,v in pairs(value) do
		if valid_buff[k] then
			if k == "setatk" then
				self.buff.setatk = nil
			elseif k == "setmaxhp" then
				self.buff.setmaxhp = nil
			elseif k == "setcrystalcost" then
				self.buff.setcrystalcost = nil
			elseif k == mincrystalcost then
				self.buff.mincrystalcost = nil
			else
				local func = self[k]
				func(self,-v,srcid,BUFF_TYPE)
			end
		end
	end
end

function cwarcard:addhalo(value,srcid)
	table.insert(self.halos,{srcid=srcid,value=value})
	for k,v in pairs(value) do
		if valid_halo[k] then
			local func = self[k]
			func(self,v,srcid,HALO_TYPE)
		end
	end
end

function cwarcard:delhalo(value)
	for k,v in pairs(value) do
		if valid_halo[k] then
			if k == "setatk" then
				self.halo.setatk = nil
			elseif k == "setmaxhp" then
				self.halo.setmaxhp = nil
			elseif k == "setcrystalcost" then
				self.halo.setcrystalcost = nil
			elseif k == mincrystalcost then
				self.halo.mincrystalcost = nil
			else
				local func = self[k]
				func(self,-v,srcid,HALO_TYPE)
			end
		end
	end
end


function cwarcard:setstate(type,flag)	
	local oldstate = self.state[type]
	self.state[type] = flag
	if not oldstate and flag then
		if type == "enrage" then
			self:__onenrage()
		end
	end
	if oldstate and not flag then
		if type == "enrage" then
			self:__onunenrage()
		end
	end
end

function cwarcard:getstate(type)
	return self.state[type]
end




function cwarcard:getmaxhp()
	local maxhp
	if self.buff.setmaxhp then
		maxhp = self.buff.setmaxhp
	else
		maxhp = self.maxhp + self.buff.addmaxhp
	end
	return maxhp + self.halo.addmaxhp
end

function cwarcard:setmaxhp(value,srcid,mode)
	assert(value > 0)
	if mode == BUFF_TYPE then
		self.buff.setmaxhp = value
	else
		assert(mode == HALO_TYPE)
		self.halo.setmaxhp = value
	end
	local maxhp = self:getmaxhp()
	if self:gethp() > maxhp then
		self:sethp(maxhp,srcid)
	end
end

function cwarcard:addmaxhp(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.addmaxhp = self.buff.addmaxhp + value
		self.buff.addhp = math.max(0,self.buff.addhp + value)
	else
		assert(mode == HALO_TYPE)
		self.halo.addmaxhp = self.halo.addmaxhp + value
		self.halo.addhp = math.max(0,self.halo.addhp + value)
	end
end

function cwarcard:gethp()
	return self.hp + self.buff.addhp + self.halo.addhp
end

function cwarcard:sethp(value,srcid)
	self.buff.addhp = 0
	self.halo.addhp = 0
	self.hp = value
	local ishurt = self:gethp() < self:getmaxhp()
	if ishurt then
		self:setstate("hurt",ishurt)
	end
	if self.hp <= 0 then
		self:__ondie()
	end
end

function cwarcard:addhp(value,srcid)
	local hp = self:gethp()
	local maxhp = self:getmaxhp()
	value = math.min(maxhp - hp,value)
	if value > 0 then
		self:__onaddhp(value)
		if self.hp < self.maxhp then
			local addval = self.maxhp - self.hp
			value = value - addval
			self.hp = self.hp + addval
		end
		if value > 0 then
			if self.halo.addhp < self.halo.addmaxhp then
				local addval = self.halo.addmaxhp - self.halo.addhp
				value = value - addval
				self.halo.addhp = self.halo.addhp + addval
			end
			if value > 0 then
				if self.buff.addhp < self.buff.addmaxhp then
					local addval = self.buff.addmaxhp - self.buff.addhp
					value = value - addval
					self.buff.addhp = self.buff.addhp + addval
				end
			end
		end
	elseif value < 0 then
		value = -value
		self:__onhurt(value)
		if self.buff.addhp > 0 then
			local costhp = math.min(self.buff.addhp,value)
			value = value - costhp
			self.buff.addhp = self.buff.addhp - costhp
		end
		if value > 0 then
			if self.halo.addhp > 0 then
				local costhp = math.min(self.halo.addhp,value)
				value = value - costhp
				self.halo.addhp = self.halo.addhp - costhp
			end
			if value > 0 then
				assert(self.hp > 0)
				self.hp = self.hp - value
				self.hurt = self.hurt + value
				if self.hp <= 0 then
					self:__ondie()
				end
			end
		end
	end
end


function cwarcard:getatk()
	local atk
	if self.buff.setatk then
		atk = self.buff.setatk
	else
		atk = self.atk + self.buff.addatk
	end
	if self.halo.setatk then
		atk = self.halo.setatk
	else
		atk = atk + self.halo.addatk
	end
	return math.max(0,atk)
end

function cwarcard:setatk(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.setatk = value
	else
		assert(mode == HALO_TYPE)
		self.halo.setatk = value
	end
end

function cwarcard:addatk(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.addatk = self.buff.addatk + value
	else
		assert(mode == HALO_TYPE)
		self.halo.addatk = self.halo.addatk + value
	end
end

function cwarcard:addcrystalcost(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.addcrystalcost = self.buff.addcrystalcost + value
	else
		assert(mode == HALO_TYPE)
		self.halo.addcrystalcost = self.halo.addcrystalcost + value
	end
end

function cwarcard:getcrystalcost()
	local crystalcost
	if self.buff.setcrystalcost then
		crystalcost = self.crystalcost
	else
		crystalcost = self.crystalcost + self.buff.addcrystalcost
	end
	if self.halo.setcrystalcost then
		crystalcost = self.halo.setcrystalcost
	else
		crystalcost = crystalcost + self.halo.addcrystalcost
	end
	local mincrystalcost = 0
	if self.buff.mincrystalcost then
		mincrystalcost = math.min(self.crystalcost,self.buff.mincrystalcost)
	end
	if self.halo.mincrystalcost then
		mincrystalcost = math.min(mincrystalcost,self.halo.mincrystalcost)
	end
	return math.max(mincrystalcost,crystalcost)
end

function cwarcard:setcrystalcost(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.setcrystalcost = value
	else
		assert(mode == BUFF_TYPE)
		self.halo.setcrystalcost = value
	end
end

function cwarcard:mincrystalcost(value,srcid,mode)
	if mode == BUFF_TYPE then
		self.buff.mincrystalcost = value
	else
		assert(mode == BUFF_TYPE)
		self.halo.mincrystalcost = value
	end
end


function cwarcard:silence(srcid)
	self:clearbuff()
	self.effects.start = #self.effects
	self:remove_produce_effect()
	local hp = self.maxhp - self.hurt
	self:sethp(hp,srcid)
end

function cwarcard:clearbuff()
	self.buff = {}
	--self.buff.setmaxhp = nil
	--self.buff.setatk = nil
	--self.buff.setcrystalcost = nil
	--self.buff.mincrystalcost = nil
	self.buff.addmaxhp = 0
	self.buff.addatk = 0
	self.buff.addcrystalcost = 0
	self.buff.addhp = 0
end

function cwarcard:clearstate()
	self.state = {}
end

function cwarcard:__onenrage()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onenrage) do
		parse_action(self,v.srcid,v.action,self)
	end
end

function cwarcard:__onunenrage()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onunenrage) do
		parse_action(self,v.srcid,v.action,self)
	end
end

function cwarcard:__onattack()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onattack) do
		parse_action(self,v.srcid,v.action,self)
	end
	local objs = warobj:getcategorys(self.type)
	for _,obj in ipairs(objs) do
		for i,v in ipairs(obj.onattack) do
			parse_action(obj,v.srcid,v.action,self)
		end
	end
end

function cwarcard:__ondefense()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondefense) do
		parse_action(self,v.srcid,v.action,self)
	end
	local objs = warobj:getcategorys(self.type)
	for _,obj in ipairs(objs) do
		for i,v in ipairs(obj.ondefense) do
			parse_action(obj,v.srcid,v.action,self)
		end
	end
end

function cwarcard:__onhurt(value)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onhurt) do
		parse_action(self,v.srcid,v.action,self)
	end
	local objs = warobj:getcategorys(self.type)
	for _,obj in ipairs(objs) do
		for i,v in ipairs(obj.onhurt) do
			parse_action(obj,v.srcid,v.action,self)
		end
	end
end

function cwarcard:__ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	self:remove_produce_effect()
	for i,v in ipairs(self.ondie) do
		parse_action(self,v.srcid,v.action,self)
	end
	local objs = warobj:getcategorys(self.type)
	for _,obj in ipairs(objs) do
		for i,v in ipairs(obj.ondie) do
			parse_action(obj,v.srcid,v.action,self)
		end
	end
end
 
function cwarcard:remove_produce_effect()
	if #self.influence_target > 0 then
		for _,targettype in ipairs(self.influence_target) do
			local targets = gettargets(targettype)
			for _,target in ipairs(targets) do
				target:remove_effect(self.id)
			end
		end
		self.influence_target = {}
	end
end

function cwarcard:remove_effect(warcardid)
	local del_halos = {}
	for i,effect in ipairs(self.halos) do
		if effect.srcid == warcardid then
			table.insert(del_halos,1,i)
		end
	end
	for i,pos in ipairs(del_halos) do
		local effect = self.halos[pos]
		table.remove(self.halos,pos)	
		for type,value in pairs(effect) do
			if type == "mincrystalcost" then
				self.halo.mincrystalcost = nil
			else
				self:subtracthalo(type,value)
			end
		end
	end
	for _,eventtype in ipairs(self.events) do
		local events = self[eventtype]
		local del_events = {}
		for i,event in ipairs(events) do
			if event.srcid == warcardid then
				table.insert(del_events,1,i)
			end
		end
		for i,pos in ipairs(del_events) do
			table.remove(events,pos)
		end
	end
end

return cwarcard
