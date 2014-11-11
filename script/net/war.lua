require "script.base"

netwar = netwar or {}

-- c2s
local REQUEST = {} 
netwar.REQUEST = REQUEST

function REQUEST.selectcardtable(player,request)
	local cardtableid = assert(request.cardtableid)
	local type = assert(request.type)
	if type == "fight" then
		player:set("fight.cardtableid",cardtableid)	
	end
end

function REQUEST.search_opponent(player,request)
	local type == assert(request.type)	
	if type == "fight" then
		local profile = player:pack_fight_profile()	
		cluster.call("warsrvmgr","war","search_opponent",profile)
	end
end

function REQUEST.confirm_handcard(player,request)
	local cardsids = assert(request.cardsids)
	cluster.call()	
end


local RESPONSE = {}
netwar.RESPONSE = RESPONSE

-- s2c
return netwar
