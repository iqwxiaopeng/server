local skynet = require "skynet"

skynet.start(function()
	local loginserver = skynet.newservice("logind")
	local gate = skynet.newservice("gated", loginserver)

	skynet.call(gate, "lua", "open" , {
		port = 8888,
		maxclient = 10240,
		servername = "gs",
	})
end)
