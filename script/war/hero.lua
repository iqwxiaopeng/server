require "script.base"
require "script.war.warmgr"
require "script.war.aux"

chero = class("chero")

function chero:init(conf)
	self.id = conf.id
	self.pid = conf.pid
	self.warid = conf.warid
	self.maxhp = conf.maxhp
	self.skillcost = conf.skillcost
	self.hp = self.maxhp
	self.atk = 0
	self.def = 0
	self.buffs = {}
	self.state = {}
	self.type = 0
	self.onattack = {}
	self.ondefense = {}
	self.onaddhp = {}
	self.onhurt = {}
end

function chero:getweapon()
	return self.weapon
end

function chero:delweapon()
	self.weapon = nil
end

function chero:equipweapon(weapon)
	self.weapon = weapon
end

function chero:useskill(targetid)
end

function chero:addbuf(value,srcid)
	table.insert(self.buffs,{srcid=srcid,value=value})
end

function chero:delbuff(srcid)
	local pos
	for i,v in ipairs(self.buffs) do
		if v.srcid == srcid then
			pos = i
			break
		end
	end
	if pos then
		return table.remove(self.buffs,pos)
	end
end

function chero:setstate(type,value)	
	self.state[type] = value
end

function chero:getstate(type)
	return self.state[type]
end

function chero:delstate(type)
	self.state[type] = nil
end

function chero:addhp(value,srcid)
	if value > 0 then
		if self:__onaddhp(value) then
			return
		end
		self.hp = math.min(self.maxhp,self.hp+value)
	else
		value = -value
		if self.def > 0 then
			local subval = math.min(self.def,value)	
			value = value - subval
			self.def = self.def - subval
		end
		if value > 0 then
			if self:__onhurt(value) then
				return
			end
			self.hp = self.hp - value
			if self.hp <= 0 then
				self:__ondie()
			end
		end
	end
end

function chero:addatk(value,srcid)
	self.atk = self.atk + value
end

function chero:addcrystalcost(value,srcid)
	self.crystalcost = self.crystalcost + value
end

function chero:setatk(value,srcid)
	self.atk = value
end

function chero:gethurtvalue()
	return self:getatk()
end

function chero:__ondefense(attacker)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondefense) do
		warcard = warobj.id_card[v]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__ondefense(attacker)
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

function chero:__onattack(target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onattack) do
		warcard = warobj.id_card[v]
		cardcls = getclassbysid(warcard.sid)
		eventresult = cardcls.__onattack(self,target)
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

function chero:__ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = warmgr.getwarobj(self.pid)
	warobj:onfail()
	warobj.enemy:onwin()
end

function chero:__onaddhp(value)
	return false
end

function chero:__onhurt(value)
	return false
end


function chero:dump()
	local data = {}
	data.id = self.id
	data.pid = self.pid
	data.warid = self.warid
	data.maxhp = self.maxhp
	data.skillcost = self.skillcost
	data.hp = self.hp
	data.atk = self.atk
	data.def = self.def
	data.buffs = self.buffs
	data.state = self.state
	data.type = self.type
	data.ondefense = self.ondefense
	data.onattack = self.onattack
	data.onaddhp = self.onaddhp
	data.onhurt = self.onhurt
	return data
end

return chero
