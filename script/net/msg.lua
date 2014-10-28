require "script.base"

netmsg = netmsg or {}
-- c2s
local REQUEST = {}
netmsg.REQUEST = REQUEST

local RESPONSE = {}
netmsg.RESPONSE = RESPONSE


-- s2c
function netmsg.notify(player,msg)
	sendpackage(player.pid,"msg","notify",{msg=msg,})
	print "ok"
end

function netmsg.messagebox(player,content,button,title)
	sendpackage(player.pid,"msg","messagebox",{
		title = title,
		content = content,
		button = button,
	})
end

return netmsg
