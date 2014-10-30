local skynet = require "skynet"
local skynet_cluster = require "cluster"

cluster = cluster or {}



function cluster.rpc(srvname,modname,funcname,...)
	local mod = _G
	if modname then
		mod = require(modname)
	end
	local func = mod[funcname]
	return func(...)
end

function dispatch (session,source,srvname,cmd,subcmd,...)
	print("manservice.lua",session,source,srvname,cmd,subcmd,...)
	local ret
	if cmd == "rpc" then
		ret = cluster.rpc(srvname,subcmd,...)
		skynet.ret(skynet.pack(ret))
	elseif cmd == "net" then
		local tbl = assert(cluster.CMD[subcmd],"[cluster] Unknow cmd:" .. tostring(subcmd))
		local func = assert(tbl.dispatch,"Not found dispatch:" .. tostring(subcmd))
		ret = func(srvname,...)
		skynet.ret(skynet.pack(ret))
	end
end

function cluster.init()
	cluster.srvname = skynet.getenv("srvname")
	skynet_cluster.open(cluster.srvname)
	require "script.friend.friendmgr"
	require "script.cluster.clustermgr"
	require "script.cluster.route"

	friendmgr.init()
	clustermgr.init()
	local CMD = {
		test = {
			dispatch = function (srvname,cmd,...) print (srvname,cmd,...) end,
		},
		cluster = clustermgr,
		route = route,
	}
	if cluster.srvname == "frdsrv" then
		CMD.friend = friendmgr
	end
	cluster.CMD = CMD

	skynet.dispatch("lua",dispatch)
end

function cluster.rpc(srvname,modname,funcname,...)
	assert(srvname ~= cluster.srvname,"cluster rpc self,srvname:" .. tostring(srvname))
	skynet_cluster.call(srvname,".mainservice",cluster.srvname,"rpc",modname,funcname,...)
end

function cluster.call(srvname,protoname,cmd,...)
	assert(srvname ~= cluster.srvname,"cluster call self,srvname:" .. tostring(srvname))
	skynet_cluster.call(srvname,".mainservice",cluster.srvname,"net",protoname,cmd,...)
end

return cluster


