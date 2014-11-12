local skynet = require "skynet"
require "script.game"
require "script.conf.srvlist"

local srvname = skynet.getenv("srvname")
local c = srvlist[srvname]
local conf = {
	port = c.port,
	maxclient = c.maxclient,
	nodelay = true,
}

local function init()
	print("Server start")
	print("package.path:",package.path)
	os.execute("pwd")
	print("srvname:",skynet.getenv("srvname"))
	skynet.register(".mainservice")
	--local console = skynet.newservice("console")
	--skynet.newservice("debug_console",8000)
	print("Watchdog listen on " .. conf.port)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",conf)
	-- script init
	game.startgame()	
end

skynet.start(init)
