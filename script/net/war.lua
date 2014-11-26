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
	local type = assert(request.type)	
	if type == "fight" then
		local profile = player:pack_fight_profile()	
		cluster.call("warsrvmgr","war","search_opponent",profile)
	end
end

function REQUEST.confirm_handcard(player,request)
	local cardsids = assert(request.cardsids)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid"))
	cluster.call(warsrvname,"war","confirm_handcard",player.pid,warid,cardsids)	
end

function REQUEST.playcard(player,request)
	local cardid = assert(request.cardid)
	local targetid = assert(request.targetid)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	cluster.call(warsrvname,"war","playcard",player.pid,warid,cardid,targetid)
end

function REQUEST.endround(player,request)
	local roundcnt = assert(request.roundcnt)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	cluster.call(warsrvname,"war","endround",player.pid,warid,roundcnt)
end

function REQUEST.launchattack(player,request)
	local attackerid = assert(request.attackerid)
	local defenserid = assert(request.defenserid)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	cluster.call(warsrvname,"war","launchattack",player.pid,warid,attackerid,defenserid)
end

function REQUEST.hero_useskill(player,request)
	local targetid = assert(request.targetid)
	local warsrvname = assert(player:query("fight.warsrvname"))
	local warid = assert(player:query("fight.warid")) 
	cluster.call(warsrvname,"war","launchattack",player.pid,warid,targetid)
end

local RESPONSE = {}
netwar.RESPONSE = RESPONSE

-- s2c
return netwar
