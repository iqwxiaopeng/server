local skynet = require "skynet"
local proto = require "script.proto"
local game = require "script.game"


skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = skynet.unpack,
	dispatch = function(session,source,cmd,subcmd,...)
		print(".logicsrv",session,source,cmd,subcmd,...)
		if cmd == "net" then
			local f = proto.CMD[subcmd]
			skynet.ret(skynet.pack(session,f(source,...)))
		end
	end,
}


local function init()
	print("Server start")
	print("package.path:",package.path)
	os.execute("pwd")
	skynet.register(".logicsrv")
	--local console = skynet.newservice("console")
	skynet.newservice("debug_console",8000)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",{
		port = 8888,
		maxclient = 10240,
		nodelay = true,
	})
	print("Watchdog listen on 8888")
	-- script init
	game.startgame()	
end

skynet.start(init)
