require "script.base"

netwar = netwar or {}

-- c2s
local REQUEST = {} 
netwar.REQUEST = REQUEST

function REQUEST.selectcardtable(player,request)
	local warcardsids = assert(request.warcardsids)
	player:set("warcardsids",warcardsids)	
end

function REQUEST.searchplayer(player,request)
	local match_player =  {
		pid = 10001,
		race = 1,
		name = "test",
		lv = 15,
		photo = 1,
		ap = {1,2,3},
	}
	local war = warmgr.createwar(player.pid,match_player.pid)
	warmgr.addwar(war)
	return match_player
end

function REQUEST.confirm_handcard(player,request)
	local cardsids = assert(request.cardsids)
	local warid = assert(player.war:query("warid"),"Not found warid")
	local war = warmgr.getwar(warid)
	if not war then
		return
	end
	local warobj = war:getwarobj(player.pid)
	local random_cardsids = war:query("random_cardsids")
	local giveup_sids = {}
	for _,sid in ipairs(random_cardsids) do
		if not findintable(cardsids) then
			table.insert(giveup_sids,sid)
		else
			local warcard = warobj:createwarcard(sid)
			warobj:add_handcard(warcard)
		end
	end
	local cardtable_sids = warobj:query("cardtable_sids")
	for _,sid in ipairs(giveup_sids) do
		local pos = math.random(1,#cardtable_sids)
		table.insert(cardtable_sids,pos,sid)
	end
end


local RESPONSE = {}
netwar.RESPONSE = RESPONSE

-- s2c
return netwar
