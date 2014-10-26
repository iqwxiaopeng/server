require "script.base"

net_test = net_test or {}

-- c2s
local REQUEST = {} 
net_test.REQUEST = REQUEST
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
net_test.RESPONSE = RESPONSE
function RESPONSE.handshake(player,request,response)
end

function RESPONSE.get(player,request,response)
end

-- s2c
function net_test.heartbeat(player)
end
return net_test
