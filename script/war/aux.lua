require "script.card.aux"

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

function is_secretcard(sid)
	local cardcls = getclassbycardsid(sid)
	if cardcls.secret == 1 then
		return true
	end
	return false
end

function is_weapon(type)
	return math.floor(type/100) % 10 == 3
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

-- targettype
TARGETTYPE_SELF_HERO = 11
TARGETTYPE_SELF_FOOTMAN = 12 
TARGETTYPE_SELF_HERO_FOOTMAN = 13
TARGETTYPE_ENEMY_HERO = 21
TARGETTYPE_ENEMY_FOOTMAN = 22
TARGETTYPE_ENEMY_HERO_FOOTMAN = 23
TARGETTYPE_ALL_HERO = 31
TARGETTYPE_ALL_FOOTMAN = 32
TARGETTYPE_ALL_HERO_FOOTMAN = 33

-- 起手随机卡牌数
ATTACKER_START_CARD_NUM = 29 --3
DEFENSER_START_CARD_NUM = 30 --4

WAR_CARD_LIMIT = 10
HAND_CARD_LIMIT = 30 --10
MAX_CARD_NUM = 200
