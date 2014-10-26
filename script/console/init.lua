local skynet = require "skynet"
local socket = require "socket"
require "script.base"

console = {}

local function console_main_loop()
	local stdin = socket.stdin()
	socket.lock(stdin)
	while true do
		local cmdline = socket.readline(stdin, "\n")
		if cmdline ~= "" then
			local func,err = load(cmdline)
			if not func then
				skynet.error("error",err)
			else
				func()
			end
		end
	end
	socket.unlock(stdin)
end

function console.init()
	skynet.fork(console_main_loop)
end
return console
