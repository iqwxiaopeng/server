local skynet = require "skynet"

local function init()
	print("Server start")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog,"lua","start",{
		port = 8888,
		maxclient = 10240,
		nodelay = true,
	})
	print("Watchdog listen on 8888")
	skynet.exit()
end

skynet.start(init)
