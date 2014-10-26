require "script.base"
require "script.gm"

net_player = net_player or {}
-- c2s
local REQUEST = {}
net_player.REQUEST = REQUEST

function REQUEST.gm(player,request)
	local cmd = assert(request.cmd)
	gm.docmd(player,cmd)
end

local RESPONSE = {}
net_player.RESPONSE = RESPONSE

return net_player


