local skynet = require "skynet"
local skynet_cluster = require "cluster"
require "script.friend.friendmgr"

cluster = cluster or {}

cluster.CMD = {
	test = function (...) print("[cluster] test",...) end,
	friend = friendmgr.dispatch,
}

function cluster.rpc(modname,funcname,...)
	local mod = _G
	if modname then
		mod = require(modname)
	end
	local func = mod[funcname]
	return func(...)
end

function cluster.init()
	cluster.srvname = skynet.getenv("servername")
	skynet_cluster.open(cluster.srvname)
	skynet.dispatch("lua",function (session,source,cmd,subcmd,...)
		print("manservice.lua",session,source,cmd,subcmd,...)
		local ret
		if cmd == "rpc" then
			ret = cluster.rpc(subcmd,...)
			skynet.ret(skynet.pack(ret))
		elseif cmd == "net" then
			local func = cluster.CMD[subcmd]
			ret = func(...)
			skynet.ret(skynet.pack(ret))
		end
	end)
end

function cluster.rpc(srvname,modname,funcname,args)
	args.srvname = cluster.srvname
	skynet_cluster.call(srvname,"rpc",modname,funcname,args)
end

function cluster.call(srvname,protoname,cmd,args)
	args.srvname = cluster.srvname
	skynet_cluster.call(srvname,"net",protoname,cmd,args)
end

return cluster


