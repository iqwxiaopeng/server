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
	warmgr.refreshwar(self.warid,self.pid,"delweapon",{id=self.id,})
	self.weapon = nil
end


function chero:equipweapon(weapon)
	self.weapon = weapon
	warmgr.refreshwar(self.warid,self.pid,"equipweapon",{id=self.id,weapon=self.weapon,})
end

function chero:useweapon()
	self.weapon.usecnt = self.weapon.usecnt - 1
	warmgr.refreshwar(self.warid,self.pid,"setweaponusecnt",{id=self.id,value=self.usecnt})
end

function chero:useskill(targetid)
	warmgr.refreshwar(self.warid,self.pid,"useskill",{id=self.id,id=targetid,})
end

function chero:addbuff(value,srcid,srcsid)
	local buff = {srcid=srcid,srcsid=srcsid,value=value}
	table.insert(self.buffs,buff)
	warmgr.refreshwar(self.warid,self.pid,"addbuff",{id=self.id,buff=buff,})
end

function chero:delbuff(srcid)
	local pos
	for i,v in ipairs(self.buffs) do
		if v.srcid == srcid then
			pos = i
			break
		end
	end
	local ret
	if pos then
		ret = table.remove(self.buffs,pos)
		warmgr.refreshwar(self.warid,self.pid,"delbuff",{id=self.id,srcid=srcid,})
	end
	return ret
end

function chero:setstate(type,newstate)	
	self.state[type] = newstate
	warmgr.refreshwar(self.warid,self.pid,"setstate",{id=self.id,state=type,value=newstate,})
end

function chero:getstate(type)
	return self.state[type]
end

function chero:delstate(type)
	self.state[type] = nil
	warmgr.refreshwar(self.warid,self.pid,"delstate",{id=self.id,state=type,})
end

function chero:addhp(value,srcid)
	logger.log("debug","war",string.format("[warid=%d] #%s hero.addhp, srcid=%d %d+%d",self.warid,self.pid,srcid,self.hp,value))
	local oldhp = self.hp
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
			if self:__onhurt(value,srcid) then
				return
			end
			self.hp = self.hp - value
		end
	end
	local newhp = self.hp
	if oldhp ~= newhp then
		warmgr.refreshwar(self.warid,self.pid,"sethp",{id=self.id,value=newhp,})
	end
	if self.hp <= 0 then
		self:__ondie()
	end
end

function chero:addatk(value,srcid)
	self.atk = self.atk + value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk,})
end

function chero:setatk(value,srcid)
	self.atk = value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk})
end

function chero:gethurtvalue()
	return self:getatk()
end

function chero:__ondefense(attacker)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.ondefense) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
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
	local owner,warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onattack) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
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


function cwarcard:__onhurt(hurtvalue,srcid)
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
		eventresult = cardcls.__onhurt(warcard,self,hurtvalue,srcid)
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
