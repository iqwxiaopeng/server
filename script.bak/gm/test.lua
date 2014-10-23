require "script.base"
local net = require "script.net"
local test = {}
--- usage: test test_filename ...
function test.test(args)
	local ok,result = pcall(checkargs,slice(args,1,1),"string")
	if not ok then
		net.msg.notify(master,"usage: test test_filename")
		return
	end
	local test_filename = table.unpack(result)
	local func = require "script.test." .. test_fllename
	print(string.format("test %s ...",test_filename))
	func(table.unpack(slice(args,2,#args)))
	print(string.format("test %s ok",test_filename))
end
return test
