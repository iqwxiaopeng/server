--------------------------------------------------
--函数包装器
--用法: f = functor(print,1,"hello")
--      f(2,"world",nil,3) ==> 1,hello,2,world,nil,3
--------------------------------------------------
local callmeta = {}
callmeta.__call = function (func,...)
	args = {...}
	if type(func) == "function" then
		return func(...)
	elseif type(func) ~= "table" then
		print(debug.traceback("functor.call",1))
	else
		local allargs = {}
		for i = 1, #func.__args do
			table.insert(allargs,func.__args[i])
		end
		for i = 1, #args do
			table.insert(allargs,args[i])
		end
		return func.__fn(unpack(allargs))
	end
end

function functor(func,...)
	args = {...}
	local wrap = {}
	wrap.__fn = func
	wrap.__args = args
	wrap.__name = "functor"  -- flag
	setmetatable(wrap,callmeta)
	return wrap
end

