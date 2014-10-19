local skynet = require "skynet"
local netpack = require "netpack"
local proto = require "script.proto"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

local host
local send_request


local playermgr = require "script.playermgr"
print("watchdog playermgr:",playermgr)
function SOCKET.open(fd, addr)
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
	--dispatch(fd,host:dispatch(msg))
end


function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
end

skynet.start(function()
	--host = sproto.parse(proto.c2s):host "package"
	--send_request = host:attach(sproto.new(proto.s2c))

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
