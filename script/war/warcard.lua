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
	self.state = {}
	self.atkcnt = 0
	self.leftatkcnt = 0

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
	self.hurt = 0
end

local valid_buff = {
	addmaxhp = true,
	addatk = true,
	setatk = true,
	setmaxhp = true,
}

local valid_halo = {
	addmaxhp = true,
	addatk = true,
	addcrystalcost = true,
	setcrystalcost = true,
	mincrystalcost = true,
}

function cwarcard:addbuff(value,srcid,srcsid)
	local buff = {srcid=srcid,srcsid=srcsid,value=value}
	table.insert(self.buffs,buff)
	warmgr.refreshwar(self.warid,self.id,"addbuff",{buff=buff,})
	for k,v in pairs(value) do
		if k == "setatk" then
			self.buffs.setatkpos = #self.buffs
			self:setatk(v)
		elseif k == "setmaxhp" then
			self.buffs.setmaxhppos = #self.buffs	
			self:setmaxhp(v)
		elseif k == "addatk" then
			self:addatk(v,BUFF_TYPE)
		elseif k == "addmaxhp" then
			self:addmaxhp(v,BUFF_TYPE)
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
		warmgr.refreshwar(self.warid,self.id,"delbuff",{id=srcid,})
		for k,v in pairs(buff.value) do
			if k == "addatk" then
				if (not self.buffs.setatkpos) or (self.buffs.setatkpos < pos) then
					self:addatk(-v,BUFF_TYPE)
				end
			elseif k == "addmaxhp" then
				if (not self.buffs.setmaxhppos) or (self.buffs.setmaxhppos < pos) then
					self:addmaxhp(-v,BUFF_TYPE)
				end
			end
		end
	end
end

function cwarcard:addhalo(value,srcid,srcsid)
	local halo = {srcid=srcid,srcsid,value=value}
	table.insert(self.halos,halo)
	warmgr.refreshwar(self.warid,self.id,"addhalo",{halo=halo,})
	if value.mincrystalcost then
		self:mincrystalcost(value.mincrystalcost)
	end
	for k,v in pairs(value) do
		if k == "addatk" then
			self:addatk(v,HALO_TYPE)
		elseif k == "addmaxhp" then
			self:addmaxhp(v,HALO_TYPE)
		elseif k == "addcrystalcost" then
			self:addcrystalcost(v)
		elseif k == "setcrystalcost" then
			self:setcrystalcost(v)
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
		warmgr.refreshwar(self.warid,self.id,"delhalo",{id=srcid,})
		for k,v in pairs(halo.value) do
			if k == "setcrystalcost" then
				self.halo.setcrystalcost = nil
			elseif k == mincrystalcost then
				self.halo.mincrystalcost = nil
			elseif k == "addcrystalcost" then
				self:addcrystalcost(-v)
			elseif k == "addatk" then
				self:addatk(-v,HALO_TYPE)
			elseif k == "addmaxhp" then
				self:addmaxhp(-v,HALO_TYPE)
			end
		end
	end
end


function cwarcard:setstate(type,newstate,bsync)	
	assert(type(newstate) == "number")
	bsync = bsync or true
	local oldstate = self.state[type]
	self.state[type] = newstate
	if oldstate ~= newstate  then
		if bsync then
			warmgr.refreshwar(self.warid,self.id,"setstate",{state=type,value=newstate})
		end
		if not oldstate and newstate then
			if type == "enrage" then
				self:onenrage()
			elseif type == "assault" then
				self:setleftatkcnt(self.atkcnt)
			end
		end
	end
end

function cwarcard:getstate(type)
	return self.state[type]
end

function cwarcard:delstate(type)
	self.state[type] = nil
	warmgr.refreshwar(self.warid,self.id,"delstate",{state=type})
	if type == "enrage" then
		self:onunenrage()
	end
end

function cwarcard:setleftatkcnt(atkcnt,bsync)
	self.leftatkcnt = atkcnt
	if bsync then
		warmgr.refreshwar(self.warid,self.id,"setleftatkcnt",{value=self.leftatkcnt,})
	end
end

function cwarcard:setatkcnt(atkcnt,bsync)
	self.atkcnt = atkcnt
	if bsync then
		warmgr.refreshwar(self.warid,self.id,"setatkcnt",{value=self.atkcnt,})
	end
end



function cwarcard:getmaxhp()
	local maxhp = self.maxhp
	if self.buff.setmaxhp then
		maxhp = self.buff.setmaxhp
	end
	return maxhp + self.buff.addmaxhp + self.halo.addmaxhp
end

function cwarcard:setmaxhp(value)
	assert(value > 0)
	self.buff.setmaxhp = value
	self.buff.addmaxhp = 0
	local maxhp = self:getmaxhp()
	warmgr.refreshwar(self.warid,self.id,"setmaxhp",{value=maxhp,})
	if self:gethp() > maxhp then
		self:sethp(maxhp)
	end
end

function cwarcard:addmaxhp(value,mode)
	if mode == BUFF_TYPE then
		self.buff.addmaxhp = self.buff.addmaxhp + value
		assert(self.buff.addmaxhp >= 0,string.format("buff.addmaxhp: %d < 0",self.buff.addmaxhp))
		self.buff.addhp = math.max(0,self.buff.addhp + value)
	else
		assert(mode == HALO_TYPE)
		self.halo.addmaxhp = self.halo.addmaxhp + value
		assert(self.halo.addmaxhp >= 0,string.format("halo.addmaxhp: %d < 0",self.halo.addmaxhp))
		self.halo.addhp = math.max(0,self.halo.addhp + value)
	end
	warmgr.refreshwar(self.warid,self.id,"setmaxhp",{value=self:getmaxhp(),})
end

function cwarcard:gethp()
	return self.hp + self.buff.addhp + self.halo.addhp
end

function cwarcard:sethp(value,bsync)
	bsync = bsync or true
	self.buff.addhp = 0
	self.halo.addhp = 0
	self.hp = value
	local hp = self:gethp()
	if bsync then
		warmgr.refreshwar(self.warid,self.id,"sethp",{value=hp,})
	end
	local ishurt = hp < self:getmaxhp()
	if ishurt then
		self:setstate("enrage",ishurt)
	end
	if self.hp <= 0 then
		self:__ondie()
	end
end

function cwarcard:addhp(value)
	local hp = self:gethp()
	logger.log("debug","war",string.format("[warid=%d] #%d warcard.addhp,id=%d %d+%d",self.warid,self.pid,self.id,hp,value))
	local maxhp = self:getmaxhp()
	local oldhp = self:gethp()
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
			self:delstate("shield")
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
			end
		end
	end
	local newhp = self:gethp()
	if oldhp ~= newhp then
		warmgr.refreshwar(self.warid,self.id,"sethp",{value=newhp,})
	end
	if self.hp <= 0 then
		self:__ondie()
	end
end


function cwarcard:getatk()
	local atk = self.atk
	if self.buff.setatk then
		atk = self.buff.setatk
	end
	atk = atk + self.buff.addatk + self.halo.addatk
	return atk
end

function cwarcard:setatk(value)
	self.buff.setatk = value
	self.buff.addatk = 0
	warmgr.refreshwar(self.warid,self.id,"setatk",{value=self:getatk(),})
end

function cwarcard:addatk(value,mode)
	if mode == BUFF_TYPE then
		self.buff.addatk = self.buff.addatk + value
		assert(self.buff.addatk >= 0,string.format("buff.addatk:%d < 0",self.buff.addatk))
	else
		assert(mode == HALO_TYPE)
		self.halo.addatk = self.halo.addatk + value
		assert(self.halo.addatk >= 0,string.format("halo.addatk:%d < 0",self.halo.addatk))
	end
	warmgr.refreshwar(self.warid,self.id,"setatk",{value=self:getatk(),})
end

function cwarcard:addcrystalcost(value)
	self.halo.addcrystalcost = self.halo.addcrystalcost + value
	warmgr.refreshwar(self.warid,self.id,"setcrystalcost",{value=self:getcrystalcost(),})
end

function cwarcard:getcrystalcost()
	if self.halo.setcrystalcost then
		return self.halo.setcrystalcost
	end
	local mincrystalcost = 0
	if self.halo.mincrystalcost then
		mincrystalcost = math.min(mincrystalcost,self.halo.mincrystalcost)
	end
	return math.max(mincrystalcost,self.crystalcost + self.halo.addcrystalcost)
end

function cwarcard:setcrystalcost(value)
	assert(value > 0)
	self.halo.setcrystalcost = value
	warmgr.refreshwar(self.warid,self.id,"setcrystalcost",{value=self:getcrystalcost(),})
end

function cwarcard:mincrystalcost(value)
	assert(value > 0)
	self.halo.mincrystalcost = value
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

function cwarcard:silence()
	self.atkcnt = 1
	self:clearstate()
	self:clearbuff()
	self.buffs.start = #self.buffs
	cardcls = getclassbycardsid(self.sid)
	cardcls.unregister(self)
	local hp = self.maxhp - self.hurt
	self:sethp(hp,false)
	warmgr.refreshwar(self.warid,self.id,"silence",{pos=self.buffs.start})
	warmgr.refreshwar(self.warid,self.pid,"synccard",{warcard=self:pack(),})
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

function cwarcard:clearstate()
	self.state = {}
end

function cwarcard:pack()
	return {
		id = self.id,
		maxhp = self:getmaxhp(),
		atk = self:getatk(),
		hp = self:gethp(),
		state = self.state,
		atkcnt = self.atkcnt,
		leftatkcnt = self.leftatkcnt,
	}
end



function cwarcard:onenrage()
	local cardcls = getclassbycardsid(warcard.sid)
	if cardcls.onenrage then
		cardcls.onenrage(self)
	end
end

function cwarcard:onunenrage()
	local cardcls = getclassbycardsid(self.sid)
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
		cardcls = getclassbycardsid(warcard.sid)
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
				cardcls = getclassbycardsid(warcard.sid)
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
		cardcls = getclassbycardsid(warcard.sid)
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
				cardcls = getclassbycardsid(warcard.sid)
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
		cardcls = getclassbycardsid(warcard.sid)
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
				cardcls = getclassbycardsid(warcard.sid)
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
		cardcls = getclassbycardsid(warcard.sid)
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
				cardcls = getclassbycardsid(warcard.sid)
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
	local cardcls = getclassbycardsid(self.sid)
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
	data.hurt = self.hurt
	data.atkcnt = self.atkcnt
	data.leftatkcnt = self.atkcnt
	data.onhurt = self.onhurt
	data.ondie = self.ondie
	data.ondefense = self.ondefense
	data.onattack = self.onattack
	return data
end

