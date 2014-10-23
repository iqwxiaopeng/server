--用户必须保证对象非递归嵌套表
function self_tostring(obj)
	if type(obj) ~= "table" then
		return tostring(obj)
	end
	local cache = {}
	table.insert(cache,"{")
	for k,v in pairs(obj) do
		if type(k) == "number" then
			--table.insert(cache,self_tostring(v)..",")
			table.insert(cache,string.format("[%d]=%s,",k,self_tostring(v)))
		else
			local str = string.format("%s=%s,",self_tostring(k),self_tostring(v))
			table.insert(cache,str)	
		end
	end
	table.insert(cache,"}")
	return table.concat(cache)
end

function format(fmt,...)
	--local args = {...}	--无法处理nil值参数
	local args = table.pack(...)
	local len = math.max(#args,args.n or 0)
	for i = 1, len do
		if type(args[i]) == "table" then
			args[i] = self_tostring(args[i])
		elseif type(args[i]) ~= "number" then
			args[i] = tostring(args[i])
		end
	end
	return string.format(fmt,unpack(args))
end

function printf(fmt,...)
	print(format(fmt,...))
end

function pretty_tostring(obj,indent)
	if type(obj) ~= "table" then
		return tostring(obj)
	end
	local cache = {}
	table.insert(cache,"{")
	indent = indent + 4
	for k,v in pairs(obj) do
		if type(k) == "number" then
			table.insert(cache,string.rep(" ",indent) .. string.format("[%d]=%s,",k,pretty_tostring(v,indent)))
		else
			local str = string.rep(" ",indent) .. string.format("%s=%s,",pretty_tostring(k,indent),pretty_tostring(v,indent))
			table.insert(cache,str)	
		end
	end
	indent = indent - 4
	table.insert(cache,string.rep(" ",indent) .. "}")
	return table.concat(cache,"\n")
end

function pretty_format(fmt,...)
	--local args = {...}	--无法处理nil值参数
	local args = table.pack(...)
	local len = math.max(#args,args.n or 0)
	for i = 1, len do
		if type(args[i]) == "table" then
			args[i] = pretty_tostring(args[i],0)
		elseif type(args[i]) ~= "number" then
			args[i] = tostring(args[i])
		end
	end
	print(fmt,args,#args)
	return string.format(fmt,unpack(args))
end

function pprintf(fmt,...)
	print(pretty_format(fmt,...))
end

pprintf("%s",{})
