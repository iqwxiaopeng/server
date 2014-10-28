require "script.base"
require "script.gm"

netplayer = netplayer or {}
-- c2s
local REQUEST = {}
netplayer.REQUEST = REQUEST

function REQUEST.gm(player,request)
	local cmd = assert(request.cmd)
	gm.docmd(player,cmd)
end

local RESPONSE = {}
netplayer.RESPONSE = RESPONSE

return netplayer


