require "script.base"

local msg = {}
-- c2s
local REQUEST = {}
msg.REQUEST = REQUEST

local RESPONSE = {}
msg.RESPONSE = RESPONSE


-- s2c
function msg.notify(player,msg)
	sendpackage(player.id,"msg","notify",{msg=msg,})
end

function msg.messagebox(player,content,button,title)
	sendpackage(player.id,"msg","messagebox",{
		title = title,
		content = content,
		button = button,
	})
end

return msg
