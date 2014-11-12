require "script.base"

ctarget = class("ctarget")

function ctarget:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.type = conf.type
	self.bufs = {}
	self.state = {}
	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
end

function ctarget:addbuf(value,srcid)
	table.insert(self.bufs,{srcid=srcid,value=value})
end

function ctarget:delbuf(srcid)
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

function ctarget:getmaxhp()
	local buf_maxhp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_maxhp = buf_maxhp + v.addmaxhp
		end
	end
	return self.maxhp + buf_maxhp
end

function ctarget:gethp()
	local buf_hp = 0
	for i,v in ipairs(self.bufs) do
		if v.addmaxhp then
			buf_hp = buf_hp + v.addmaxhp - (v.costhp or 0)
		end
	end
	return self.hp + buf_hp
end

function ctarget:addmaxhp(value,srcid)
	assert(value > 0)
	self.maxhp = self.maxhp + value
	self.hp = self.hp + value
end

function ctarget:setmaxhp(value,srcid)
	assert(value > 0)
	self.maxhp = value
	self.hp = math.min(self.hp,self.maxhp)
end

function ctarget:addhp(value,srcid)
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



function ctarget:setstate(type,flag)	
	self[type] = flag
end

function ctarget:addatk(value,srcid)
	self.atk = self.atk + value
end

function ctarget:addcrystalcost(value,srcid)
	self.crystalcost = self.crystalcost + value
end

function ctarget:setatk(value,srcid)
	self.atk = value
end

function ctarget:setcrystalcost(value,srcid)
	self.crystalcost = value
end

function ctarget:__onattack()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local obj
	if is_animal_footman(self.type) then
		obj = warobj.animal_footman
	elseif is_fish_footman(self.type) then
		obj = warobj.fish_footman
	elseif isfootman(self.type) then
		obj = warobj.footman
	end
	assert(obj,"Invalid type:" .. tostring(self.type))
	self:parse_event(warobj,obj.onattack)
end

function ctarget:__ondefense()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local obj
	if is_animal_footman(self.type) then
		obj = warobj.animal_footman
	elseif is_fish_footman(self.type) then
		obj = warobj.fish_footman
	elseif isfootman(self.type) then
		obj = warobj.footman
	end
	assert(obj,"Invalid type:" .. tostring(self.type))
	self:parse_event(warobj,obj.ondefense)
end

function ctarget:__onhurt(value)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local obj
	if is_animal_footman(self.type) then
		obj = warobj.animal_footman
	elseif is_fish_footman(self.type) then
		obj = warobj.fish_footman
	elseif isfootman(self.type) then
		obj = warobj.footman
	end
	assert(obj,"Invalid type:" .. tostring(self.type))
	self:parse_event(warobj,obj.onhurt)
end

function ctarget:__ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local obj
	if is_animal_footman(self.type) then
		obj = warobj.animal_footman
	elseif is_fish_footman(self.type) then
		obj = warobj.fish_footman
	elseif isfootman(self.type) then
		obj = warobj.footman
	end
	assert(obj,"Invalid type:" .. tostring(self.type))
	self:parse_event(warobj,obj.ondie)
end

function ctarget:parse_event(warobj,events)
	for i,v in ipairs(events) do
		local targettype = v.target
		local target
		if targettype == "trigger" then
			target = self
		elseif type(targettype) == "number" then
			target = warobj.id_card[targettype]
		else
			target = warobj
			for k in string.gmatch(targettype,"([^.]+)") do
				target = target[k]
			end
		end
		assert(target,"Not found target,targettype:" .. tostring(targettype) )
		if v.condition then
			if not v:hascondtion(v.condtion) then
				return
			end
		end
		for k1,v1 in pairs(v.value) do
			local func = target[k1]
			func(target,v1,v.srcid)
		end
	end
end

return ctarget
