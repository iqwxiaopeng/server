require "script.base"
local net = require "script.net"
local test = {}
--- usage: test test_filename ...
function test.test(args)
	if #args < 1 then
		net.msg.notify(master,"usage: test test_filename ...")
		return
	end
	local test_filename = args[1]
	local func = require "script.test." .. test_fllename
	func(slice(args,2,#args))
end
return test
