require "script.base"

netmsg = netmsg or {}
-- c2s
local REQUEST = {}
netmsg.REQUEST = REQUEST

local RESPONSE = {}
netmsg.RESPONSE = RESPONSE


-- s2c
function netmsg.notify(pid,msg)
	sendpackage(pid,"msg","notify",{msg=msg,})
	print "ok"
end

function netmsg.messagebox(pid,content,button,title)
	sendpackage(pid,"msg","messagebox",{
		title = title,
		content = content,
		button = button,
	})
end

return netmsg
