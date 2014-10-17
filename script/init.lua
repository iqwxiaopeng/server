local skynet = require "skynet"
playermgr = require "script.playermgr"
proto = require "script.proto"
db = require "script.db"
timectrl = require "script.timectrl"
logger = require "script.base.logger"

local function startgame()
	print("Start game...")
	logger.init()
	proto.init()
	db.init()
	playermgr.init()
	timectrl.init()
	print("Start game ok")
end

local function init()
	print("Server start")
	--package.path = package.path .. ";" .. skynet.getenv("script")
	print("package.path:",package.path)
	local console = skynet.newservice("console")
	skynet.newservice("debug_console",8000)
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog,"lua","start",{
		port = 8888,
		maxclient = 10240,
		nodelay = true,
	})
	print("Watchdog listen on 8888")

	-- script init
	startgame()	
	skynet.exit()
end

skynet.start(init)
