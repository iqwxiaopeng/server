require "script.base"
local gm = require "script.gm"

local playermod = {}
-- c2s
local REQUEST = {}
playermod.REQUEST = REQUEST

function REQUEST.gm(player,request)
	local cmd = assert(request.cmd)
	gm.docmd(player,cmd)
end

local RESPONSE = {}
playermod.RESPONSE = RESPONSE

return playermod


