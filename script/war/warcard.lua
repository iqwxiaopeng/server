require "script.base"
require "script.card.aux"
require "script.war.aux"
require "script.card.aux"

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
	self.effect = {}
	self.state = {}

	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
	self:clearbuff()
	self:clearhalo()
	self:initproperty()
end

function cwarcard:initproperty()
	local cardcls = getclassbycardsid(self.sid)
	self.type =  cardcls.type
	self.maxhp = cardcls.hp
	self.hp = self.maxhp
	self.atk = cardcls.atk
	self.magic_hurt = cardcls.magic_hurt
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
	local buff = {srcid=srcid,value=value}
	table.insert(self.buffs,buff)
	for k,v in pairs(value) do
		if valid_buff[k] then
			local func = self[k]
			func(self,v,srcid,BUFF_TYPE)
		end
	end
end

function cwarcard:delbuff(srcid,start)
	start = start or 1
	local pos
	for i = start,#self.buffs do
		local buff = self.buffs[i]
		if buff.srcid == srcid then
			pos = i
			break
		end
	end
	if pos then
		local buff = self.buffs[pos]
		table.remove(self.buffs,pos)
		for k,v in pairs(buff.value) do
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
end

function cwarcard:addhalo(value,srcid)
	local buff = {srcid=srcid,value=value}
	table.insert(self.halos,buff)
	for k,v in pairs(value) do
		if valid_halo[k] then
			local func = self[k]
			func(self,v,srcid,HALO_TYPE)
		end
	end
end

function cwarcard:delhalo(srcid,start)
	start = start or 1
	local pos
	for i = start,#self.halos do
		local halo = self.halos[i]
		if halo.srcid == srcid then
			pos = i
			break
		end
	end
	if pos then
		local halo = self.halos[pos]
		table.remove(self.halos,pos)
		for k,v in pairs(halo.value) do
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
end


function cwarcard:setstate(type,value)	
	local oldstate = self.state[type]
	self.state[type] = value
	if not oldstate and value then
		if type == "enrage" then
			self:onenrage()
		end
	end
	if oldstate and not value then
		if type == "enrage" then
			self:onunenrage()
		end
	end
end

function cwarcard:getstate(type)
	return self.state[type]
end

function cwarcard:delstate(type)
	self.state[type] = nil
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
		self:setstate("enrage",ishurt)
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
		if self:__onaddhp(value) then
			return
		end
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
		if self:getstate("shield") then
			self:setstate("shield",false)
			return
		end
		value = -value
		if self:__onhurt(value) then
			return
		end
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

function cwarcard:gethurtvalue()
	if is_footman(self.type) then
		return self:getatk()
	else
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		return self.magic_hurt + warobj:get_addition_magic_hurt()
	end
end

function cwarcard:silence(srcid)
	self:clearbuff()
	self.buffs.start = #self.buffs
	self:cleareffect()
	cardcls = getclassbysid(self.sid)
	cardcls.unregister(self)
	local hp = self.maxhp - self.hurt
	self:sethp(hp,srcid)
end

function cwarcard:clearbuff()
	self.buff = {}
	self.buff.addmaxhp = 0
	self.buff.addatk = 0
	self.buff.addcrystalcost = 0
	self.buff.addhp = 0
end

function cwarcard:clearhalo()
	self.halo = {}
	self.halo.addmaxhp = 0
	self.halo.addatk  = 0
	self.halo.addcrystalcost = 0
	self.halo.addhp = 0
end

function cwarcard:cleareffect()
	for k,v in pairs(self.effect) do
		self.effect[k] = {}
	end
end

function cwarcard:clearstate()
	self.state = {}
end



function cwarcard:onenrage()
	local cardcls = getclassbysid(warcard.sid)
	if cardcls.onenrage then
		cardcls.onenrage(self)
	end
end

function cwarcard:onunenrage()
	local cardcls = getclassbysid(self.sid)
	if cardcls.onunenrage then
		cardcls.onunenrage(self)
	end
end

function cwarcard:__onattack(target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onattack) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__onattack(warcard,self,target)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	if ignoreevent ~= IGNORE_ALL_LATER_EVENT then
		local categorys = warobj:getcategorys(self.type,self.sid,false)
		for _,category in ipairs(categorys) do
			for _,id in ipairs(category.onattack) do
				owner = war:getowner(id)
				warcard = owner.id_card[id]
				cardcls = getclassbysid(warcard.sid)
				eventresult = cardcls.__onattack(warcard,self,target)
				if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
					ret = true
				end
				ignoreevent = EVENTRESULT_FIELD2(eventresult)
				if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
					break
				end
			end
		end
	end
	return ret
end

function cwarcard:__ondefense(attacker)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.ondefense) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__ondefense(warcard,attacker)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	if ignoreevent ~= IGNORE_ALL_LATER_EVENT then
		local categorys = warobj:getcategorys(self.type,self.sid,false)
		for _,category in ipairs(categorys) do
			for _,id in ipairs(category.ondefense) do
				owner = war:getowner(id)
				warcard = owner.id_card[id]
				cardcls = getclassbysid(warcard.sid)
				eventresult = cardcls.__ondefense(warcard,attacker)
				if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
					ret = true
				end
				ignoreevent = EVENTRESULT_FIELD2(eventresult)
				if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
					break
				end
			end
		end
	end
	return ret
end

function cwarcard:__onhurt(hurtvalue)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onhurt) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__onhurt(warcard,self,hurtvalue)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	if ignoreevent ~= IGNORE_ALL_LATER_EVENT then
		local categorys = warobj:getcategorys(self.type,self.sid,false)
		for _,category in ipairs(categorys) do
			for _,id in ipairs(category.onhurt) do
				owner = war:getowner(id)
				warcard = owner.id_card[id]
				cardcls = getclassbysid(warcard.sid)
				eventresult = cardcls.__onhurt(warcard,self,hurtvalue)
				if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
					ret = true
				end
				ignoreevent = EVENTRESULT_FIELD2(eventresult)
				if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
					break
				end
			end
		end
	end
	return ret
end

function cwarcard:__ondie()
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:removefromwar(self)
	for _,id in ipairs(self.ondie) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__ondie()
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	if ignoreevent ~= IGNORE_ALL_LATER_EVENT then
		local categorys = warobj:getcategorys(self.type,self.sid,false)
		for _,category in ipairs(categorys) do
			for _,id in ipairs(category.ondie) do
				owner = war:getowner(id)
				warcard = owner.id_card[id]
				cardcls = getclassbysid(warcard.sid)
				eventresult = cardcls.__ondie()
				if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
					ret = true
				end
				ignoreevent = EVENTRESULT_FIELD2(eventresult)
				if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
					break
				end
			end
		end
	end
	return ret
end

 
function cwarcard:use(target)
	local cardcls = getclassbysid(self.sid)
	if cardcls.use then
		cardcls.use(self,target)
	end
end

function cwarcard:dump()
	local data = {}
	data.id = self.id
	data.sid = self.sid
	data.warid = self.warid
	data.pid = self.pid
	data.inarea = self.inarea
	data.pos = self.pos
	data.state = self.state
	data.halos = self.halos
	data.buffs = self.buffs
	data.buff = self.buff
	data.hp = self.hp
	data.maxhp = self.maxhp
	data.atk = self.atk
	data.magic_hurt = self.magic_hurt
	data.crystalcost = self.crystalcost
	data.onhurt = self.onhurt
	data.ondie = self.ondie
	data.ondefense = self.ondefense
	data.onattack = self.onattack
	return data
end

return cwarcard
