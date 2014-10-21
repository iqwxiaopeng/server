local skynet = require "skynet"
local socket = require "socket"

local console = {}

local function console_main_loop()
	local stdin = socket.stdin()
	socket.lock(stdin)
	while true do
		local cmdline = socket.readline(stdin, "\n")
		if cmdline ~= "" then
			local func = load(cmdline)
			local ok,result = pcall(func)
			--print(ok,result)
			if not ok then
				print(result)
			end
		end
	end
	socket.unlock(stdin)
end

function console.init()
	skynet.fork(console_main_loop)
end
return console
