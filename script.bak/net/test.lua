require "script.base"

local test = {}

-- c2s
local REQUEST = {} 
test.REQUEST = REQUEST
function REQUEST.handshake(player)
	return {msg = "Welcome to skynet server"}
end

function REQUEST.get(player,request)
	-- simple echo
	return {result = request.what}
end

function REQUEST.set(player,request)
end


local RESPONSE = {}
test.RESPONSE = RESPONSE
function RESPONSE.handshake(player,request,response)
end

function RESPONSE.get(player,request,response)
end

-- s2c
function test.heartbeat(player)
end
return test
