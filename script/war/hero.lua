require "script.base"

chero = class("chero")

function chero:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.maxhp = conf.maxhp
	self.skillcost = conf.skillcost
	self.hp = self.maxhp
	self.atk = 0
	self.bufs = {}
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
	table.insert(self.bufs,{srcid=srcid,value=value})
end

function chero:delbuf(srcid)
	local delbufs = {}
	for i,v in ipairs(self.bufs) do
		if v.srcid == srcid then
			table.insert(delbufs,i)
		end
	end
	for _,pos in ipairs(delbufs) do
		table.remove(self.bufs,pos)
	end
end

function chero:getmaxhp()
	local buf_maxhp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_maxhp = buf_maxhp + v.addmaxhp
		end
	end
	return self.maxhp + buf_maxhp
end

function chero:gethp()
	local buf_hp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_hp = buf_hp + v.addmaxhp - (v.costhp or 0)
		end
	end
	return self.hp + buf_hp
end

function chero:addmaxhp(value,srcid)
	assert(value > 0)
	self.maxhp = self.maxhp + value
	self.hp = self.hp + value
end

function chero:setmaxhp(value,srcid)
	assert(value > 0)
	self.maxhp = value
	self.hp = math.min(self.hp,self.maxhp)
end

function chero:addhp(value,srcid)
	if value < 0 then
		self:__ondefense()
		if self.shield then
			self.shield = false
			return
		end
		if self.def and self.def > 0 then
			value = self.def + value
			self.def = math.max(0,value)
			value = math.min(0,value)
			if value == 0 then
				return
			end
		end
		for i,v in ipairs(self.bufs) do
			if v.addmaxhp then 
				if v.addmaxhp > 0 then
					if not v.costhp then
						v.costhp = 0
					end
					local lefthp = v.addmaxhp - v.costhp
					if lefthp > 0 then
						if value + lefthp < 0 then
							v.costhp = v.costhp - lefthp
							value = value + lefthp
						else
							v.costhp = v.costhp + value
							value = 0
							break
						end
					end
				end
			end
		end
		self:__onhurt(value)
	end
	local maxhp = self:getmaxhp()
	self.hp = math.min(self.hp + value,maxhp)
	local hp = self:gethp()
	if hp < maxhp then
		self:setstate("hurt",true)
	else
		self:setstate("hurt",false)
	end
	if hp <= 0 then
		self:__ondie()
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

return chero
