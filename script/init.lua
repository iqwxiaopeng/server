local skynet = require "skynet"
playermgr = require "script.playermgr"
proto = require "script.proto"
db = require "script.db"
timectrl = require "script.timectrl"
logger = require "script.base.logger"
net = require "script.net"

local function startgame()
	print("Start game...",playermgr)
	logger.init()
	db.init()
	playermgr.init()
	timectrl.init()
	proto.dump()
	print("Start game ok")
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function(msg,sz)
		return "test"
	end,
	dispatch = function(session,source,msg)
		print(session,source,msg)
	end,
}


local function init()
	print("Server start")
	print("package.path:",package.path)
	skynet.register("logicserver")
	-- script init
	startgame()	
	--local console = skynet.newservice("console")
	skynet.newservice("debug_console",8000)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",{
		port = 8888,
		maxclient = 10240,
		nodelay = true,
	})
	print("Watchdog listen on 8888")
	skynet.exit()
end

skynet.start(init)
