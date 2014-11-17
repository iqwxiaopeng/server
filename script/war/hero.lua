require "script.base"

chero = class("chero")

function chero:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.maxhp = conf.maxhp
	self.skillcost = conf.skillcost
	self.hp = self.maxhp
	self.atk = 0
	self.buffs = {}
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
		end
	end
	if pos then
		return table.remove(self.buffs,pos)
	end
end

function chero:setstate(type,flag)	
	self[type] = flag
end

function chero:getstate(type)
	return self[type]
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

function chero:__ondefense(attacker)
	local ret = false
	local war = warmgr.getwar(self.warid)
	for i,warcardid in ipairs(self.ondefense) do
		local owner = war:getowner(warcardid)
		local warcard = owner.id_card[warcardid]
		local cardcls = getclassbysid(warcard.sid)
		if cardcls.hero.__ondefense(self,attacker) then
			ret = true
		end
	end
	return ret
end

function chero:register(type,warcardid)
	return register(self,type,warcardid)
end

function chero:unregister(type,warcardid)
	return unregister(self,type,warcardid)
end

return chero
