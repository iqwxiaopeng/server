local skynet = require "skynet"
require "script.base"
require "script.playermgr"
require "script.net.war"
require "script.war.aux"

local function test(pid1,pid2,race,cardrace)
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	player1.carddb:clear()
	player1.cardtablelib:clear()
	player2.carddb:clear()
	player2.cardtablelib:clear()
	local cardsids = {}
	race = race or RACE_GOLDEN
	cardrace = cardrace or race
	for i = 1,30 do
		local cardsid = random_racecard(cardrace)
		local carddb = player1:getcarddbbysid(cardsid)
		carddb:addcardbysid(cardsid,1,"test")
		carddb = player2:getcarddbbysid(cardsid)
		carddb:addcardbysid(cardsid,1,"test")
		table.insert(cardsids,cardsid)
	end
	local cardtable = {
		id = 1,
		mode = CARDTABLE_MODE_NORMAL,
		cards = cardsids,
		race = race,
	}
	--pprintf("cardtable:%s",cardtable)
	player1.cardtablelib:updatecardtable(cardtable)
	player2.cardtablelib:updatecardtable(cardtable)
	assert(player1.cardtablelib:getcardtable(1,CARDTABLE_MODE_NORMAL))
	assert(player2.cardtablelib:getcardtable(1,CARDTABLE_MODE_NORMAL))

	netwar.REQUEST.selectcardtable(player1,{
		type = "fight",
		cardtableid = 1,
	})
	netwar.REQUEST.selectcardtable(player2,{
		type = "fight",
		cardtableid = 1,
	})
	netwar.REQUEST.search_opponent(player1,{
		type = "fight",
	})
	netwar.REQUEST.search_opponent(player2,{
		type = "fight",
	})
	skynet.sleep(200)
	local warid = assert(player1:query("fight.warid"))
	local warsrvname = assert(player1:query("fight.warsrvname"))
	cluster.call(warsrvname,"modmethod","war.ai.inject_ai",warid,pid1)
	cluster.call(warsrvname,"modmethod","war.ai.inject_ai",warid,pid2)
	netwar.REQUEST.confirm_handcard(player1,{
		poslist = {},
	})	
	netwar.REQUEST.confirm_handcard(player2,{
		poslist = {},
	})	


end

return test

