local skynet = require "skynet"
require "script.game"

local conf = {
	port = 8888,
	maxclient = 10240,
	nodelay = true,
}

if skynet.getenv("servername") == "frdsrv" then
	conf.port = 7777
end

local function init()
	print("Server start")
	print("package.path:",package.path)
	os.execute("pwd")
	skynet.register(".logicsrv")
	--local console = skynet.newservice("console")
	--skynet.newservice("debug_console",8000)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",conf)
	print("Watchdog listen on " .. conf.port)
	-- script init
	game.startgame()	
end

skynet.start(init)
