local local_var = "local_var"
global_var = "global_var"

local local_cnt = 0
local function local_func(...)
	print("local_func",...)
	local_cnt = local_cnt + 1
	print("local_cnt",local_cnt)
end

function global_func(...)
	print("global_func",...)
	local_func(...)
	local_var = local_var .. "." .. local_var
	print("local_var",local_var)
	global_var = global_var .. "." .. global_var
	print("global_var",global_var)
end

return function ()
	print "returnfunc"
end
