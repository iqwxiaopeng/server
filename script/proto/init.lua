sproto = require "sproto"
local net = require "script.net"

local proto_meta = {}
local proto = setmetatable({},{__index=proto_meta,})

function proto_meta.register(protoname)
	local protomod = require("script.proto." .. protoname)
	proto.s2c = proto.s2c .. protomod.s2c
	proto.c2s = proto.c2s .. protomod.c2s
end

function proto_meta.dump()
	local lineno
	local b,e
	print("s2c:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.s2c,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(proto.s2c,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
	print("c2s:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.c2s,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(proto.c2s,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
end

--function watchdog.send_request(protoname,cmd,args,onresponse)
--	agent.session = agent.session + 1
--	agent.sessions[agent.session] = {
--		protoname = protoname,
--		cmd = cmd,
--		args = args,
--		onresponse = onresponse,
--	}	
--	local str = agent.request(protoname .. "_" .. cmd,args,agent.session)
--	agent.send_package(str)
--end
--
--local function request(cmd,args,response)
--	pprintf("REQUEST:%s",{
--		cmd = cmd,
--		args = args,
--		response = response,
--	})
--	local obj = assert()
--	local protoname,cmd = string.match(cmd,"([^_]-)%_(.+)") 
--	local REQUEST = net[protoname].REQUEST
--	local func = assert(REQUEST[cmd],"unknow cmd:" .. protoname,"." .. cmd)
--	local r = func(obj,args)
--	if response then
--		return response(r)
--	end
--end
--
--local function onresponse(fd,session,args)
--	pprintf("RESPONSE:%s",{
--		id = obj.id,
--		session = session,
--		args = args,
--	})
--	local agent = obj.__agent
--	local ses = assert(agent.sessions[session],"error session id:%s" .. tostring(session))
--	local callback = ses.onresponse
--	if not callback then
--		callback = net[ses.protoname].RESPONSE[ses.cmd]
--	end
--	if callback then
--		local ok,result = pcall(callback,obj,session,args)
--		if not ok then
--			skynet.error(result)
--		end
--	end
--	agent.sessions[session] = nil
--end
--
--local function dispatch(fd,typ,...)
--	if typ == "REQUEST" then
--		local ok,result = pcall(request,fd,...)
--		if ok then
--			if result then
--				send_package(result)
--			end
--		else
--			skynet.error(result)
--		end
--	else
--		assert(typ == "RESPONSE")
--		onresponse(fd,...)
--	end
--	
--end
--

function proto_meta.init()
	proto.s2c = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	proto.c2s = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	for protoname,netmod in pairs(net) do
		proto_meta.register(protoname)
	end
end

proto.init()
return proto
