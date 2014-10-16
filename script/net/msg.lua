require "script.base"

local msg = {}
-- c2s
local REQUEST = {}
msg.REQUEST = REQUEST

-- s2c
local RESPONSE = {}
msg.RESPONSE = RESPONSE

function msg.notify(player,msg)
	sendpackage(player,"msg","notify",{msg=msg,})
end
return msg
