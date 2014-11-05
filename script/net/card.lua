require "script.base"

netcard = netcard or {}

-- c2s
local REQUEST = {} 
netcard.REQUEST = REQUEST
function REQUEST.updatecardtable(player,request)
	local id = assert(request.id)	
	local roletype = assert(request.roletype)
	local cards = assert(request.cards)
	local mode = assert(request.mode)

end

local RESPONSE = {}

-- s2c

return netcard
