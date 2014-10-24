require "script.base"
local playermgr = require "script.playermgr"

function test(pid)
	pid = tonumber(pid)
	local player = playermgr.getplayer(pid)	
	if not player then
		return	
	end
	player:addcardbysid(11101,3)
	pprintf("card:%s",player.carddb:save())
	player:delcardbysid(11101,1)
	pprintf("card:%s",player.carddb:save())
	local result = player:delcardbysid(11101,4)
	pprintf("result:%s",result)
	player:delcardbysid(11101,2)
	pprintf("card:%s",player.carddb:save())
	player:addcardbysid(11101,4)
	player:addcardbysid(21101,3)
	player:addcardbysid(41201,10) -- error
	pprintf("card:%s",player.carddb:save())
end

return test
