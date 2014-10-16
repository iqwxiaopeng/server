local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"

require "script.base"
require "script.playermgr"

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

function agent.send_request(protoname,cmd,args,onresponse)
	agent.session = agent.session + 1
	agent.sessions[agent.session] = {
		protoname = protoname,
		cmd = cmd,
		args = args,
		onresponse = onresponse,
	}	
	local str = agent.request(protoname .. "_" .. cmd,args,agent.session)
	agent.send_package(str)
end

local function request(obj,cmd,args,response)
	pprintf("REQUEST:%s",{
		cmd = cmd,
		args = args,
		response = response,
	})
	local protoname,cmd = string.match(cmd,"([^_]-)%_(.+)") 
	local REQUEST = net[protoname].REQUEST
	local func = assert(REQUEST[cmd],"unknow cmd:" .. protoname,"." .. cmd)
	local r = func(obj,args)
	if response then
		return response(r)
	end
end

local function onresponse(obj,session,args)
	pprintf("RESPONSE:%s",{
		id = obj.id,
		session = session,
		args = args,
	})
	local agent = obj.__agent
	local ses = assert(agent.sessions[session],"error session id:%s" .. tostring(session))
	local callback = ses.onresponse
	if not callback then
		callback = net[ses.protoname].RESPONSE[ses.cmd]
	end
	if callback then
		callback(obj,session,args)
	end
	agent.sessions[session] = nil
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return agent.host:dispatch(msg, sz)
	end,
	dispatch = function (_, _, typ, ...)
		local obj = assert(playermgr.getobject(agent.id),"unknow object id:" .. tostring(agent.id))
		if typ == "REQUEST" then
			local ok,result = pcall(request,obj,...)
			if ok then
				if result then
					agent.send_package(result)
				end
			else
				error(result)
			end
		else
			assert(typ == "RESPONSE")
			onresponse(obj,...)
		end
	end
}

function CMD.start(gate, fd, addr,proto)
	agent.host = sproto.parse(proto.c2s):host "package"
	agent.request = agent.host:attach(sproto.parse(proto.s2c))
	agent.fd = fd
	agent.ip = addr
	
	local obj = cobject.new(agent)
	agent.id = assert(obj.id)
	playermgr.addobject(obj)
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.close()
	playermgr.delobject(agent.id)	
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)

return agent
