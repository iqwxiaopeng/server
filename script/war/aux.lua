local function gettargets(targettypes,referto_id)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(referto_id)
	local targets = {}
	for targettype in string.gmatch("([^;]+)") do
		local obj = owner
		for k in string.match("([^.]+)") do
			if k ~= "self" then
				obj = obj[k]	
			end
		end
		assert(obj,"Invalid targettype:" .. tostring(targettype))
		table.insert(targets,obj)
	end
	return targets
end

local valid_event = {
	onhurt = true,
	ondie = true,
	onattack = true,
	ondefense = true,
	onadd = true,
	ondel = true,
}

local function isevent(event)
	return valid_event[event]
end

local valid_condition = {
	freeze = true,
	unfreeze = true,
	hurt = true,
	unhurt = true,
	sneer = true,
	unsneer = true,
	dblatk = true,
	undblatk = true,
	sneak = true,
	unsneak = true,
}

local function iscondition(condition)
	return valid_condtion[condtion]
end

function is_animal_footman(type)
	if is_footman(type) then
		return type % 10 == 2
	end
end

function is_fish_footman(type)
	if is_footman(type) then
		return type % 10 == 3
	end
end

function is_footman(type)
	return math.floor(type/100) % 10 == 2
end

function is_magiccard(type)
	return math.floor(type/100) % 10 == 1
end

function is_prettycard(sid)
	return math.floor(sid/10000) == 1
end

function register(obj,type,warcardid)
	local tbl = obj
	for k in string.gmatch(type,"([^.]+)") do
		tbl = assert(tbl[k],"Invalid register type:" .. tostring(type))
	end
	table.insert(tbl,warcardid)
end

function unregister(obj,type,warcardid)
	local tbl = obj
	for k in string.gmatch(type,"([^.]+)") do
		tbl = assert(tbl[k],"Invalid unregister type:" .. tostring(type))
	end
	for pos,id in ipairs(tbl) do
		if id == warcardid then
			table.remove(tbl,pos)
			break
		end
	end
end

IGNORE_NONE = 0
IGNORE_LATER_EVENT = 1
IGNORE_ALL_LATER_EVENT = 2
IGNORE_ACTION = 1

function EVENTRESULT(field1,field2)
	return field1 * 10 + field2
end

function EVENTRESULT_FIELD1(eventresult)
	return math.floor(eventresult / 10)
end

function EVENTRESULT_FIELD2(eventresult)
	return eventresult % 10
end

--function parse_warcry(self,warcardid,effects,seltarget)
--	local warid = self.warid
--	local war = warmgr.getwar(warid)
--	local owner = war:getowner(warcardid)
--	local warcard = assert(owner.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))
--	local pos = seltarget.pos
--	for targettype,effect in pairs(effects) do
--		if type(targettype) == "number" then
--			for cmd,value in pairs(effect) do
--				local func = self[cmd]
--				func(self,value,warcardid)
--			end
--		else
--			local targets
--			if targettype == "seltarget" then
--				targets = {seltarget,}
--			elseif targettype == "lefttarget" then
--				targets = {self.warcards[pos-1],}
--			elseif targettype == "righttarget" then
--				targets = {self.warcards[pos+1],}
--			elseif targettype == "cardself" then
--				targets = {warcard,}
--			else
--				targets = gettargets(warid,targettype,warcardid)
--			end
--			for condition,action in pairs(effect) do
--				if type(condtion) == "number" then
--					for _,target in ipairs(targets) do
--						for cmd,value in pairs(action) do
--							local func = target[cmd]
--							func(target,value,warcardid)
--						end
--					end
--				else
--					assert(iscondtion(condtion),"Invalid condtion:" .. tostring(condtion))
--					for _,target in ipairs(targets) do
--						if target:hascondtion(condtion) then
--							for cmd,value in pairs(action) do
--								local func = target[cmd]
--								func(target,value,warcardid)
--							end
--						end
--					end
--				end
--			end
--		end
--	end
--end
--
--function parse_aliveeffect(self,warcardid,effects)
--	local warid = self.warid
--	local war = warmgr.getwar(warid)
--	local owner = war:getowner(warcardid)
--	local warcard = assert(owner.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))
--	local pos = seltarget.pos
--	for targettype,effect in pairs(effects) do
--		assert(type(targettype) == "string", "Invalid targettype:" .. tostring(targettype))
--		table.insert(warcard.influence_target,targettype)
--		local targets
--		if targettype == "cardself" then
--			targets = {warcard,}
--		else
--			targets = gettargets(warid,targettype,warcardid)
--		end
--		for condition,action in pairs(effect) do
--			if type(condtion) == "number" then
--				for _,target in ipairs(targets) do
--					for cmd,value in pairs(action) do
--						local func = target[cmd]
--						func(target,value,warcardid)
--					end
--				end
--			else
--				local event = condtion
--				for _,target in ipairs(targets) do
--					local events = assert(target[event],"Invalid event:" .. tostring(event))
--					table.insert(events,{srcid=warcardid,action=action})
--				end
--			end
--		end
--	end
--end
--
--function parse_action(self,warcardid,effects,trigger)
--	local warid = self.warid
--	local war = warmgr.getwar(warid)
--	local owner = war:getowner(warcardid)
--	local warcard = owner.id_card[warcardid]
--	local pos = seltarget.pos
--	for targettype,effect in pairs(effects) do
--		if type(targettype) == "number" then
--			for cmd,value in pairs(effect) do
--				local func = self[cmd]
--				func(self,value,warcardid)
--			end
--		else
--			local targets
--			if targettype == "cardself" then
--				targets = {warcard,}
--			elseif targettype == "trigger" then
--				targets = {trigger,}
--			else
--				targets = gettargets(warid,targettype,warcardid)
--			end
--			for condition,action in pairs(effect) do
--				if type(condtion) == "number" then
--					for _,target in ipairs(targets) do
--						for cmd,value in pairs(action) do
--							local func = target[cmd]
--							func(target,value,warcardid)
--						end
--					end
--				else
--					assert(iscondtion(condtion),"Invalid condtion:" .. tostring(condtion))
--					for _,target in ipairs(targets) do
--						if target:hascondtion(condtion) then
--							for cmd,value in pairs(action) do
--								local func = target[cmd]
--								func(target,value,warcardid)
--							end
--						end
--					end
--				end
--			end
--		end
--	end
--end

