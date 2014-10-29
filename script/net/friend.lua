require "script.base"
require "script.friend.friendmgr"

netfriend = netfriend or {}

-- c2s
local REQUEST = {}
netfriend.REQUEST = REQUEST
function REQUEST.apply_addfriend(player,request)
	local pid = assert(request.pid)
	
end

function REQUEST.agree_addfriend(player,request)
end

function REQUEST.reject_addfriend(player,request)
end

function REQUEST.delfriend(player,request)
end

function REQUEST.sendmsg(player,request)
end


local RESPONSE = {}
netfriend.RESPONSE = RESPONSE

-- s2c
function netfriend.sync(pid,request)
	sendpackage(pid,"friend","sync",request)
end

local typs = {applyer = 0,friend = 1,toapply = 2,}
function netfriend.dellist(pid,typ,pids)
	typ = assert(typs[typ],"Invalid friend type:" .. tostring(typ))
	if type(pids) == "number" then
		pids = {pids,}
	end
	sendpackage(pid,"friend","dellist",{
		pids = pids,
		typ = typ,
	})
end

function netfriend.addlist(pid,typ,pids,newflag)
	typ = assert(typs[typ],"Invalid friend type:" .. tostring(typ))
	if type(pids) == "number" then
		pids = {pids,}
	end
	sendpackage(pid,"friend","addlist",{
		pids = pids,
		typ = typ,
		newflag = newflag,
	})
end

function netfriend.addmsgs(pid,srcpid,msgs)
	if type(msgs) == "string" then
		msgs = {msgs,}
	end
	sendpackage(pid,"friend","addmsgs",{
		pid = srcpid,
		msgs = msgs,
	})
end

return netfriend

