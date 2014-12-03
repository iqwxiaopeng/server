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
	self.atkcnt = 1
	self.leftatkcnt = 0
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
	local cardid = self.weapon.id
	self.weapon = nil
	local war = warmgr.getwar(self.warid)
	local owner = war:getwarobj(self.pid)
	local card = owner.id_card[cardid]
	card:ondelweapon(self)
end


function chero:equipweapon(weapon)
	self.weapon = weapon
	warmgr.refreshwar(self.warid,self.pid,"equipweapon",{id=self.id,weapon=self.weapon,})
	local cardid = weapon.id
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(cardid)
	local card = owner.id_card[cardid]
	card:onequipweapon(hero)
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
	local oldstate = self.state[type]
	if oldstate ~= newstate then
		logger.log("debug","war",string.format("#%d hero.setstate,type=%s,state:%s->%s",self.pid,type,oldstate,newstate))
		self.state[type] = newstate
		warmgr.refreshwar(self.warid,self.pid,"setstate",{id=self.id,state=type,value=newstate,})
	end

end

function chero:getstate(type)
	return self.state[type]
end

function chero:delstate(type)
	local oldstate = self.state[type]
	if oldstate then
		logger.log("debug","war",string.format("#%d hero.delstate,type=%s",self.pid,type))
		self.state[type] = nil
		warmgr.refreshwar(self.warid,self.pid,"delstate",{id=self.id,state=type,})
	end
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
		-- 免疫状态回合结束时结算
		if self:getstate("immune") then
			return
		end
		value = -value
		if self.def > 0 then
			local subval = math.min(self.def,value)	
			value = value - subval
			self:adddef(-subval)
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

function chero:adddef(value)
	self.def = self.def + value
	warmgr.refreshwar(self.warid,self.pid,"setdef",{id=self.id,value=self.def})
end

function chero:addatk(value,srcid)
	self.atk = self.atk + value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk,})
end

function chero:setatk(value,srcid)
	self.atk = value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk})
end

function chero:getatk()
	local atk = self.atk
	local weapon = self:getweapon()
	if weapon then
		atk = atk + weapon.atk
	end
	return atk
end

function chero:gethurtvalue()
	return self:getatk()
end

function chero:onbeginround(roundcnt)
end

local lifecircle_states = {
	freeze = true,
	immune = true,
}
	
function chero:onendround(roundcnt)
	for state,_ in pairs(lifecircle_states) do
		local lifecircle = self:getstate(state)
		if lifecircle then
			lifecircle = lifecircle - 1
			if lifecircle <= 0 then
				self:delstate(state)
			else
				self:setstate(state,lifecircle)
			end
		end
	end
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
		eventresult = cardcls.__ondefense(warcard,attacker,self)
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
		eventresult = cardcls.__onattack(warcard,self,target)
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


function chero:__onhurt(hurtvalue,srcid)
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
