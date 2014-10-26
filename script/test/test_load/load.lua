local returnfunc = require "script.test.test_load.returnfunc"
local returntbl = require "script.test.test_load.returntbl"
local noreturn = require "script.test.test_load.noreturn"
print("returnfunc",returnfunc)
print("returntbl",returntbl)
print("noreturn",noreturn)

local function envid(f)
	local i = 1
	while true do
		local name, value = debug.getupvalue(f, i)
		if name == nil then
			return
		end
		if name == "_ENV" then
			return debug.upvalueid(f, i)
		end
		i = i + 1
	end
end

local function collect_uv(f , uv, env)
	local i = 1
	while true do
		local name, value = debug.getupvalue(f, i)
		if name == nil then
			break
		end
		local id = debug.upvalueid(f, i)

		if uv[name] then
			assert(uv[name].id == id, string.format("ambiguity local value %s", name))
		else
			uv[name] = { func = f, index = i, id = id }

			if type(value) == "function" then
				if envid(value) == env then
					collect_uv(value, uv, env)
				end
			end
		end
		i = i + 1
	end
end

local function collect_all_uv(funcs)
	local global = {}
	for _, v in pairs(funcs) do
		if v[4] then
			collect_uv(v[4], global, envid(v[4]))
		end
	end

	return global
end

local function find_func(...)
	local args = {...}
	local func = _G
	for _,v in ipairs() do
		func = func[v]
	end
	for _, desc in pairs(funcs) do
		local _, g, n = table.unpack(desc)
		if group == g and name == n then
			return desc
		end
	end
end

local dummy_env = {}

local function patch()

local function patch_func(global,func,...)
	local args = {...}
	local oldfunc = _G
	for _,v in ipairs(args) do
		oldfunc = oldfunc[v]
	end
	local desc = assert(find_func(func,...) , string.format("Patch mismatch:%s",table.concat(args,".")))
	local i = 1
	while true do
		local name, value = debug.getupvalue(f, i)
		if name == nil then
			break
		elseif value == nil or value == dummy_env then
			local old_uv = global[name]
			if old_uv then
				debug.upvaluejoin(func, i, old_uv.func, old_uv.index)
			end
		end
		i = i + 1
	end
	desc[4] = func
end

-- [TEST]
local function dump(name,tbl)
	print(name,tbl)	
	for k,v in pairs(tbl) do
		print(k,v)
		if type(v) == "table" then
			for k1,v1 in pairs(v) do
				print(k1,v1)
			end
		end
	end
end

local function inject(funcs, source, ...)
	local patch = si("patch", dummy_env, loader(source))
	local global = collect_all_uv(funcs)
	--dump("funcs",funcs)
	--dump("patch",patch)
	--print("global",global)
	--for k,v in pairs(global) do
	--	print(k,v)
	--end
	for _, v in pairs(patch) do
		local _, group, name, f = table.unpack(v)
		if f then
			patch_func(funcs, global, group, name, f)
		end
	end

	local hf = find_func(patch, "system", "hotfix")
	if hf and hf[4] then
		return hf[4](...)
	end
end

return function (funcs, source, ...)
	return pcall(inject, funcs, source, ...)
end

function reload(modname)
	local filename = "./script/" .. string.gsub(modname,"/") .. ".lua"
	local oldmod = package.loaded[modname]
	if not oldmod then
		print(string.format("unload mod:%s,not need to reload",modname))
		return
	end
	local env = {}
	local chunk,err = loadfile(filename,"bt",env)
	if not chunk then
		error(err)
	end
	local newmod = chunk()
	for k,v in pairs(env) do
		if type(v) == "table" then
		elseif type(v) == "function" then

		end
	end
end
