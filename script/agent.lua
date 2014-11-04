local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"

local CMD = {}
local agent = {}

function agent.sendpackage(pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack
	assert(agent.fd)
	socket.write(agent.fd, package)
end

skynet.register_protocol { 
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function(msg,sz)
		return agent.host:dispatch(msg,sz)
	end,
	dispatch = function(session,source,typ,...)
		if typ == "REQUEST" then
			local cmd,request,response = ...
			local result = skynet.call(".mainservice","lua","client","data",typ,cmd,request)
			if response then
				local result = response(result)
				agent.sendpackage(result)	
			end
		else
			assert(typ == "RESPONSE")
			skynet.send(".mainservice","lua","client","data",typ,...)
		end
	end,
}

function CMD.start(gate, fd,addr)
	agent.fd = fd
	agent.ip = addr
	local proto = require "script.proto.proto"
	agent.host = sproto.parse(proto.c2s):host "package"
	agent.send_request = agent.host:attach(sproto.parse(proto.s2c))
	skynet.call(gate, "lua", "forward", fd)
	skynet.send(".mainservice","lua","client","start",fd,addr)
end

function CMD.close()
	agent.fd = nil
	agent.ip = nil
	skynet.send(".mainservice","lua","client","close")
end

function CMD.send_request(cmd,request,session)
	local pack = agent.send_request(cmd,request,session)
	agent.sendpackage(pack)
end

function CMD.sendpackage(pack)
	agent.sendpackage(pack)
end

skynet.start(function()
	skynet.dispatch("lua", function(session,source, command, ...)
		local f = CMD[command]
		print("agent.dispatch",f,command,...)
		f(...)
	end)
end)

return agent
