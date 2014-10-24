local skynet = require "skynet"
local socket = require "socket"
require "script.base"

local console = {}

local function console_main_loop()
	local stdin = socket.stdin()
	socket.lock(stdin)
	while true do
		local cmdline = socket.readline(stdin, "\n")
		if cmdline ~= "" then
			local func = load(cmdline)
			xpcall(func,onerror)
		end
	end
	socket.unlock(stdin)
end

function console.init()
	skynet.fork(console_main_loop)
end
return console
