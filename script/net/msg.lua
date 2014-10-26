require "script.base"

net_msg = net_msg or {}
-- c2s
local REQUEST = {}
net_msg.REQUEST = REQUEST

local RESPONSE = {}
net_msg.RESPONSE = RESPONSE


-- s2c
function net_msg.notify(player,msg)
	sendpackage(player.pid,"msg","notify",{msg=msg,})
	print "ok"
end

function net_msg.messagebox(player,content,button,title)
	sendpackage(player.pid,"msg","messagebox",{
		title = title,
		content = content,
		button = button,
	})
end

return net_msg
