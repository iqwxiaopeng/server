require "script.base"

local test = {}

-- c2s
local REQUEST = {} 
test.REQUEST = REQUEST
function REQUEST.heartbeat(player)
end

local RESPONSE = {}
test.RESPONSE = RESPONSE
function RESPONSE.handshake(player,session,args)
end

function RESPONSE.get(player,session,args)
end

-- s2c
function test.handshake(player)
	pprintf("%s",{
		direction = "c2s",
		srvname = srvname,
		cmd = "test.handshake",
		args = nil,
	})
	sendpackage(player.id,"test","handshake")
end

function test.get(player,args)
	pprintf("%s",{
		direction = "c2s",
		srvname = srvname,
		cmd = "test.get",
		args = args,
	})
	sendpackage(player.id,"test","get",args)
end

function test.set(player,args)
	pprintf("%s",{
		direction = "c2s",
		svrname = srvname,
		cmd = "test.set",
		args = args,
	})
	sendpackage(player.id,"test","set",args)
end

return test
