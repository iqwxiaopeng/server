require "script.base.timer"

__refreshs = __refreshs or {}
__cache = __cache or {}

local function setvalue(tbl,val,...)
	local args = {...}
	assert(#args >= 1,"setvalue no key")
	local lastmod = tbl
	local lastkey
	for i = 1,#args-1 do
		lastkey = args[i]
		if not lastmod[lastkey] then
			lastmod[lastkey] = {}
		end
		lastmod = lastmod[lastkey]
	end
	lastmod[args[#args]] = val
end

netcache = {}

function netcache.dump(printf)
	printf("__refreshs:%s",__refreshs)
	printf("__cache:%s",__cache)
end

function netcache.register_refresh(name,key,func,delay)
	assert(delay==nil or type(delay) == "number","error delay type" .. tostring(type(delay)))
	setvalue(__refreshs,{func=func,delay=delay},name,key)
	if delay then
		setvalue(__refreshs,true,delay,name,key)
		if not __cache[delay] then
			setvalue(__cache,{},delay)
		end
	end
end


function netcache.update(id,name,key,val)
	print("netcache.update",id,name,key,val)
	-- 根据需求处理val为nil值的情况(属性被删除时)，默认不处理
	local net
	if __refreshs[name] then
		net = __refreshs[name][key]
	end
	if not net then
		return
	end
	if not net.delay then
		if net.func then
			net.func(id,name,key,val)
		else
			netcache.default_refresh(id,{[name]={[key]=val}})
		end
	else
		setvalue(__cache,val,net.delay,id,name,key)
	end
end

function netcache.refresh(delay)
	timer.timeout("netcache.timer",delay,functor(netcache.refresh,delay))
	local starttime = os.clock()
	local netdata = __cache[delay]
	local func
	for id,data in pairs(netdata) do
		local hasleft = false
		for name,v in pairs(data) do
			for key,val in pairs(v) do
				func = __refreshs[name][key].func
				if func then
					func(id,name,key,val)
					setvalue(data,nil,name,key)
				else
					hasleft = true
				end
			end
		end
		if hasleft then
			netcache.default_refresh(id,data)
			setvalue(netdata,{},id)
		end
	end
	print(string.format("%.2f refresh cost:%.6f",delay,os.clock()-starttime))
end

function netcache.starttimer()
	for delay,v in pairs(__cache) do
		-- do untimeout first?
		timer.timeout("netcache.timer",delay,functor(netcache.refresh,delay))
	end
end

function netcache.main()
	netcache.register_all()
	netcache.starttimer()
end

function netcache.reload(oldmodule)
	netcache.register_all()
	netcache.starttimer()
end

function netcache.default_refresh(id,data)
	require "gamelogic.net.netrolebase"
	local playerObj = g_serverinfo.playermanager:GetPlayer(id)
	if not playerObj then
		return
	end
	net_netrolebase:S2CRefresh(playerObj,data)
end

function netcache.register_all()
	netcache.register_refresh("ctask_catch_ghost.today","circle")
	netcache.register_refresh("basicattr","title")
	netcache.register_refresh("today","tianting_cnt")
end

return netcache
