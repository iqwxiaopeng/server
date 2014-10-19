require "script.base"

local test = {}

-- c2s
local REQUEST = {} 
test.REQUEST = REQUEST
function REQUEST.handshake(player)
	return {msg = "Welcome to skynet server"}
end

function REQUEST.get(player,args)
	-- simple echo
	return {result = args.what}
end

function REQUEST.set(player,args)
end


local RESPONSE = {}
test.RESPONSE = RESPONSE
function RESPONSE.handshake(player,session,args)
end

function RESPONSE.get(player,session,args)
end

-- s2c
function REQUEST.heartbeat(player)
end
return test
