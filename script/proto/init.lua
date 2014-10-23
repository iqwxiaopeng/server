local skynet = require "skynet"
local sproto = require "sproto"
local net = require "script.net"
local playermgr = require "script.playermgr"
require "script.object"

local proto = {}

function proto.register(protoname)
	local protomod = require("script.proto." .. protoname)
	proto.s2c = proto.s2c .. protomod.s2c
	proto.c2s = proto.c2s .. protomod.c2s
end

function proto.dump()
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

local connection = {}
local host
local send_request

proto.connection = connection

function proto.sendpackage(agent,protoname,cmd,request,onresponse)
	local connect = assert(connection[agent],"invalid agent:" .. tostring(agent))
	connect.session = connect.session + 1
	pprintf("Request:%s\n",{
		pid = connect.pid,
		session = connect.session,
		agent = skynet.address(agent),
		protoname = protoname,
		cmd = cmd,
		request = request,
		onresponse = onresponse,
	})
	connect.sessions[connect.session] = {
		protoname = protoname,
		cmd = cmd,
		request = request,
		onresponse = onresponse,
	}
	local str = send_request(protoname .. "_" .. cmd,request,connect.session)
	skynet.send(agent,"lua","sendpackage",str)
end

local function onrequest(agent,cmd,request,response)
	local connect = assert(connection[agent],"invalid agent:" .. tostring(agent))
	local obj = assert(playermgr.getobject(connect.pid),"invalid objid:" .. tostring(connect.pid))
	pprintf("REQUEST:%s\n",{
		pid = obj.pid,
		agent = skynet.address(agent),
		cmd = cmd,
		request = request,
	})
	local protoname,cmd = string.match(cmd,"([^_]-)%_(.+)") 
	local REQUEST = net[protoname].REQUEST
	local func = assert(REQUEST[cmd],"unknow cmd:" .. protoname .. "." .. cmd)

	local r = func(obj,request)
	pprintf("Response:%s\n",{
		pid = obj.pid,
		cmd = cmd,
		response = r,
	})
	if response then
		return response(r)
	end
end

local function onresponse(agent,session,response)
	local connect = assert(connection[agent],"invlaid agent:" .. tostring(agent))
	local obj = assert(playermgr.getobject(connect.pid),"invalid objid:" .. tostring(connect.pid))
	pprintf("RESPONSE:%s\n",{
		pid = obj.pid,
		agent = skynet.address(agent),
		session = session,
		response = response,
	})
	local ses = assert(connect.sessions[session],"error session id:%s" .. tostring(session))
	connect.sessions[session] = nil
	local callback = ses.onresponse
	if not callback then
		callback = net[ses.protoname].RESPONSE[ses.cmd]
	end
	if callback then
		callback(obj,ses.request,response)
	end
end

local function dispatch(agent,typ,...)
	if typ == "REQUEST" then
		local ok,result = pcall(onrequest,agent,...)
		if ok then
			if result then
				skynet.send(agent,"lua","sendpackage",result)
			end
		else
			skynet.error(result)
		end
	else
		assert(typ == "RESPONSE")
		onresponse(agent,...)
	end
end

local CMD = {}
proto.CMD = CMD
function CMD.data(agent,msg,sz)
	dispatch(agent,host:dispatch(msg,sz))
end

function CMD.start(agent,fd,ip)
	local obj = cobject.new(agent,fd,ip)
	playermgr.addobject(obj)
	connection[agent] = {
		pid = obj.pid,
		session = 0,
		sessions = {},
	}
end

function CMD.close(agent)
	local connect = assert(connection[agent],"invalid agent:" .. tostring(agent))
	connect.sessions = nil
	local pid = assert(connect.pid,"invalid objid:" .. tostring(connect.pid))
	playermgr.delobject(pid)
	connection[agent] = nil
end

function proto.init()
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
		if protoname ~= "init" then
			proto.register(protoname)
		end
	end
	host = sproto.parse(proto.c2s):host "package"
	send_request = host:attach(sproto.parse(proto.s2c))
	proto.dump()
end

return proto
