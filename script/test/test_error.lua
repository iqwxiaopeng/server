local skynet = require "skynet"

local function err()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	error("error msg")
end

local function assert_fail()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	assert(0==1,"assert msg")
end

local function collect_localvar(level)
	local ret = {}
	local i = 0
	while true do
		i = i + 1
		local name,value = debug.getlocal(level,i)
		if not name then
			break
		end
		table.insert(ret,string.format("%s=%s",name,value))
	end
	return ret
end

local function onerror(msg)
	local level = 4
	pcall(function ()
		local vars = collect_localvar(level+2)
		table.insert(vars,1,"error: " .. tostring(msg))
		local msg = debug.traceback(table.concat(vars,"\n"),level)
		skynet.error(msg)
	end)
end

local function test()
	xpcall(err,onerror)
	xpcall(assert_fail,onerror)
end

return test
