require "script.base"

function getclassbysid(sid)
	require "script.card.cardmodule"
	return cardmodule[sid]
end

local race_name = {
	[1] = "golden",
	[2] = "wood",
	[3] = "water",
	[4] = "fire",
	[5] = "soil",
	[6] = "neutral",
}
function getracename(race)
	return assert(race_name[race],"invalid race:" .. tostring(race))
end

function getqualitybysid(sid)
	-- 1--橙;2--紫;3--蓝;4--白
	return math.floor(sid / 100) % 10
end

function isgoldencard(sid)
	return math.floor(sid / 10000) == 2
end

local __classified_card
function getclassifiedcard()
	if __classified_card then
		return __classified_card
	end
	require "script.card.cardmodule"
	__classified_card = {}
	local quality,isgolden
	for sid,cardcls in pairs(cardmodule) do
		quality = getqualitybysid(sid)
		isgolden = isgoldencard(sid)
		if not __classified_card[quality] then
			__classified_card[quality] = {}
		end
		if not __classified_card[quality][isgolden] then
			__classified_card[quality][isgolden] = {}
		end
		table.insert(__classified_card[quality][isgolden],sid)
	end
	pprintf("__classified_card:%s",__classified_card)
	return __classified_card
end

local ratio = {[1] = 100,[2] = 400,[3] = 1000,[4] = 5500,[21] = 25,[22] = 100,[23] = 250,[24] = 1375,}
local __ratiotable
local function getratiotable()
	if __ratiotable then
		return __ratiotable
	end
	local classified_card = getclassifiedcard()
	local typs ={}
	for quality,v in pairs(classified_card) do
		for isgolden,v1 in pairs(v) do
			print(isgolden,quality)
			typ = quality
			if isgolden then
				typ = 20 + quality
			end
			typs[typ] = v1
		end
	end
	__ratiotable = {}
	for typ,sids in pairs(typs) do
		__ratiotable[sids] = assert(ratio[typ],"Invalid type:" .. tostring(typ))
	end
	pprintf("__ratiotable:%s",__ratiotable)
	--logger.log("info","test",format("__ratiotable:%s",__ratiotable))
	return __ratiotable
end

function randomcard(cnt,limit)
	cnt = cnt or 5
	limit = limit or cnt
	limit = math.min(limit,cnt)
	local ratiotable = getratiotable()
	local ret = {}
	local limits = {}
	while true do
		local sids = choosekey(ratiotable)
		local sid = randlist(sids)
		if not limits[sid] then
			limits[sid] = 0
		end
		limits[sid] = limits[sid] + 1
		if limits[sid] <= limit then
			table.insert(ret,sid)
		end
		if #ret == cnt then
			break
		end
	end
	return ret
end
