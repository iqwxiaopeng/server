local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"

require "script.base"
require "script.object"
local playermgr = require "script.playermgr"
local net = require "script.net"

local CMD = {}
local agent = {}

function agent.send_package(pack)
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
	unpack = function (msg, sz)
		return netpack.tostring(msg,sz) 
	end,
	dispatch = function(session,source,msg)
		skynet.send(agent.watchdog,"lua","socket","data",agent.fd,msg)
	end
}

function CMD.start(source,gate, fd)
	agent.fd = fd
	agent.watchdog = source
end


skynet.start(function()
	skynet.dispatch("lua", function(session,source, command, ...)
		local f = CMD[command]
		print(f,command,...)
		skynet.ret(skynet.pack(f(source,...)))
	end)
end)

return agent
