print(package.path)
local skynet = require "skynet"
local netpack = require "netpack"
local proto = require "script.proto"
print("proto",proto)

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

local host
local send_request


function 
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

local function request(cmd,args,response)
	pprintf("REQUEST:%s",{
		cmd = cmd,
		args = args,
		response = response,
	})
	local obj = assert()
	local protoname,cmd = string.match(cmd,"([^_]-)%_(.+)") 
	local REQUEST = net[protoname].REQUEST
	local func = assert(REQUEST[cmd],"unknow cmd:" .. protoname,"." .. cmd)
	local r = func(obj,args)
	if response then
		return response(r)
	end
end

local function onresponse(fd,session,args)
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
		local ok,result = pcall(callback,obj,session,args)
		if not ok then
			skynet.error(result)
		end
	end
	agent.sessions[session] = nil
end

local function dispatch(fd,typ,...)
	if typ == "REQUEST" then
		local ok,result = pcall(request,fd,...)
		if ok then
			if result then
				send_package(result)
			end
		else
			skynet.error(result)
		end
	else
		assert(typ == "RESPONSE")
		onresponse(fd,...)
	end
	
end


function SOCKET.open(fd, addr)
	connect[fd] = cobject.new()
	agent[fd] = skynet.newservice("script/agent")
	skynet.call(agent[fd], "lua", "start", gate, fd)
end

local function close_agent(fd)
	local a = agent[fd]
	if a then
		skynet.call(a,"lua","close")
		skynet.kill(a)
		agent[fd] = nil
	end
end

function SOCKET.close(fd)
	print("socket close",fd)
	close_agent(fd)
end

function SOCKET.error(fd, msg)
	print("socket error",fd, msg)
	close_agent(fd)
end

function SOCKET.data(fd, msg)
	dispatch(fd,host:dispatch(msg))
end


function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
end

skynet.start(function()
	host = sproto.parse(proto.c2s):host "package"
	send_request = host:attach(sproto.new(proto.s2c))

	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "socket" then
			local f = SOCKET[subcmd]
			print(f,subcmd,...)
			f(...)
			-- socket api don't need return
		else
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)

	gate = skynet.newservice("gate")
end)
