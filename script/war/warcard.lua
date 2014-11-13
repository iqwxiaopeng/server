require "script.base"
require "script.card.aux"
require "script.war.aux"

cwarcard = class("cwarcard")

function cwarcard:init(conf)
	self.id = assert(conf.id)
	self.sid = assert(conf.sid)
	self.warid = assert(conf.warid)
	self.pid = assert(conf.pid)
	self.pos = nil
	self.inarea = "cardlib"
	self.bufs = {}
	self.state = {}
	self.influence_target = {} -- 站场效果施加到的若干目标

	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
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

local valid_buf = {
	addmaxhp = true,
	setmaxhp = true,
	addatk = true,
	setatk = true,
	addcrystalcost = true,
	setcrystalcost = true,
}

function cwarcard:addbuf(value,srcid)
	table.insert(self.bufs,{srcid=srcid,value=value})
	for k,v in pairs(value) do
		if valid_buf[k] then
			local func = self[k]
			func(self,v,srcid)
		end
	end
end

function cwarcard:delbuf(srcid)
	local delbufs = {}
	for i,v in ipairs(self.bufs) do
		if v.srcid == srcid then
			table.insert(delbufs,i)
		end
	end
	for _,pos in ipairs(delbufs) do
		local buf = table.remove(self.bufs,pos)
		for k,v in pairs(buf) do
			local func = self[k]
			func(self,-v,srcid,true)
		end
	end
end

function cwarcard:getmaxhp()
	local buf_maxhp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_maxhp = buf_maxhp + v.addmaxhp
		end
	end
	return self.maxhp + buf_maxhp
end

function cwarcard:gethp()
	local buf_hp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_hp = buf_hp + v.addmaxhp - (v.costhp or 0)
		end
	end
	return self.hp + buf_hp
end

function cwarcard:getcrystalcost()
	local buf_crystalcost = 0
	local mincrystalcost
	local maxcrystalcost
	for i,v in ipairs(self.bufs) do
		if v.addcrystalcost then
			buf_crystalcost = buf_crystalcost + v.addcrystalcost
		end
		if v.maxcrystalcost then
			if not maxcrystalcost or v.maxcrystalcost > maxcrystalcost then
				maxcrystalcost = v.maxcrystalcost
			end
		end
		if v.mincrystalcost then
			if not mincrystalcost or v.mincrystalcost < mincrystalcost then
				mincrystalcost = v.mincrystalcost
			end
		end
	end
	local crystalcost = self.crystalcost + buf_crystalcost
	if mincrystalcost then
		mincrystalcost = math.min(self.crystalcost,mincrystalcost)
		crystalcost = math.max(mincrystalcost,self.crystalcost + buf_crystalcost)
	end
	if maxcrystalcost then
		maxcrystalcost = math.max(self.crystalcost,maxcrystalcost)
		crystalcost = math.min(maxcrystalcost,self.crystalcost + buf_crystalcost)
	end
	return crystalcost
end

function cwarcard:addmaxhp(value,srcid,mode)
	if mode then
		local cardcls = getclassbycardsid(self.sid)
		value = -value
		self.maxhp = self.maxhp + value
		self.hp = math.max(self.hp + value,cardcls.hp)
	else
		self.maxhp = self.maxhp + value
		self.hp = self.hp + value
	end
end

function cwarcard:setmaxhp(value,srcid,mode)
	if mode then
		assert(self.old_maxhp)
		assert(self.old_hp)
		self.maxhp = self.old_maxhp
		self.hp = math.min(self.old_hp,self.maxhp)
	else
		assert(value > 0)
		self.old_maxhp = self.maxhp
		self.old_hp = self.hp
		self.maxhp = value
		self.hp = math.min(self.hp,self.maxhp)
	end
end

function cwarcard:addatk(value,srcid,mode)
	if mode then
		value = -value
	end
	self.atk = self.atk + value
end

function cwarcard:addcrystalcost(value,srcid,mode)
	if mode then
		value = -value
	end
	self.crystalcost = self.crystalcost + value
end

function cwarcard:setatk(value,srcid,mode)
	if mode then
		assert(self.old_atk)
		self.atk = self.old_atk
	else
		self.old_atk = self.atk
		self.atk = value
	end
end

function cwarcard:setcrystalcost(value,srcid,mode)
	if mode then
		assert(self.old_crystalcost)
		self.crystalcost = self.old_crystalcost
	else
		self.old_crystalcost = self.crystalcost
		self.crystalcost = value
	end
end

function cwarcard:addhp(value,srcid)
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
							v.costhp = v.costhp + lefthp
							value = value + lefthp
						else
							v.costhp = v.costhp - value
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



function cwarcard:setstate(type,flag)	
	self[type] = flag
end



function cwarcard:__onattack()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onattack) do
		parseeffect(self,v.srcid,v.action,self)
	end
	local obj = warobj:getcategory(self.type)
	for i,v in ipairs(obj.onattack) do
		parseeffect(obj,v.srcid,v.action,self)
	end
end

function cwarcard:__ondefense()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondefense) do
		parseeffect(self,v.srcid,v.action,self)
	end
	local obj = warobj:getcategory(self.type)
	for i,v in ipairs(obj.ondefense) do
		parseeffect(obj,v.srcid,v.action,self)
	end
end

function cwarcard:__onhurt(value)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onhurt) do
		parseeffect(self,v.srcid,v.action,self)
	end
	local obj = warobj:getcategory(self.type)
	for i,v in ipairs(obj.onhurt) do
		parseeffect(obj,v.srcid,v.action,self)
	end
end

function cwarcard:__ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.ondie) do
		parseeffect(self,v.srcid,v.action,self)
	end
	local obj = warobj:getcategory(self.type)
	for i,v in ipairs(obj.ondie) do
		parseeffect(obj,v.srcid,v.action,self)
	end
end


return cwarcard
