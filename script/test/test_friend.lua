require "script.base"

local function test(pid1,pid2)
	local player1 = assert(playermgr.getplayer(pid1))
	local player2 = assert(playermgr.getplayer(pid2))
	player1.frienddb:clear()
	player2.frienddb:clear()
	pprintf("%d: %s",pid1,player1.frienddb:save())
	pprintf("%d: %s",pid2,player2.frienddb:save())
	player1.frienddb:apply_addfriend(pid2)
	pprintf("%d: %s",pid1,player1.frienddb:save())
	pprintf("%d: %s",pid2,player2.frienddb:save())
	player2.frienddb:reject_addfriend(pid1)
	pprintf("%d: %s",pid1,player1.frienddb:save())
	pprintf("%d: %s",pid2,player2.frienddb:save())
	player1.frienddb:apply_addfriend(pid2)
	player2.frienddb:agree_addfriend(pid1)
	pprintf("%d: %s",pid1,player1.frienddb:save())
	pprintf("%d: %s",pid2,player2.frienddb:save())
	player1.frienddb:apply_addfriend(pid2)
	player2.frienddb:agree_addfriend(pid1)
	for pid = 11000,11061 do
		player1.frienddb:apply_addfriend(pid)
		player1.frienddb:addfriend(pid)
	end
	pprintf("%d: %s",pid1,player1.frienddb:save())
end

return test
