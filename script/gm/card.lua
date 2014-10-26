require "script.base"
require "script.gm"
require "script.net"
require "script.playermgr"

gm_card = gm_card or {}

--- usage: addcard pid sid amount
--- e.g.:  addcard 10001 11001 10
function gm_card.addcard(args)
	local ok,result = checkargs(args,"int","int","int")
	if not ok then
		net.msg.notify(master,"usage: addcard sid amount")	
		return
	end
	local pid,sid,amount = table.unpack(result)
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master,string.format("player(%d) not online",pid))
		return
	end
	player:addcardbysid(sid,amount)
end

--- usage: delcard pid sid amount
--- e.g. : delcard 10001 11001 10
function gm_card.delcard(args)
	local ok,result = checkargs(args,"int","int","int")	
	if not ok then
		net.msg.notify(master,"usage: delcard pid sid amount")
		return
	end
	local pid,sid,amount = table.unpack(result)
	local player = playermgr.getpalyer(pid)
	if not player then
		net.msg.notify(master,string.format("player(%d) not online",pid))
		return
	end
	player:delcardbysid(sid,amount)
end

--- usage: clearcard pid racename
--- e.g. : clearcard 10001 all
function gm_card.clearcard(args)
	local ok,result = checkargs(args,"int","string")
	if not ok then
		net.msg.notify(master,"usage: clearcard pid")
		return
	end
	local pid,racename = table.unpack(result)
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master,string.format("player(%d) not online",pid))
		return
	end
	if racename == "all" then
		player.carddb:clear()
	else
		local carddb = player.carddb.getcarddb_byname(racename)
		carddb:clear()
	end
end

return gm_card
