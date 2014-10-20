require "script.base"
local gm = require "script.gm"

local playermod = {}
-- c2s
local REQUEST = {}
playermod.REQEUST = REQUEST

function REQUEST.gm(player,args)
	local cmd = assert(args.cmd)
	gm.docomd(player,cmd)
end

local RESPONSE = {}
playermod.RESPONSE = RESPONSE

return playermod


