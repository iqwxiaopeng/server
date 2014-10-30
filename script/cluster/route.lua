local skynet = require "skynet"
require "script.base"
require "script.globalmgr"
require "script.playermgr"
require "script.conf.srvlist"
require "script.logger"

route = route or {}

function route.init()
	require "script.cluster.clustermgr"
	route.map = {}
	route.sync_state = {}
	for srvname,_ in pairs(srvlist) do
		route.map[srvname] = {}
		route.sync_state[srvname] = false
	end
	local self_srvname = skynet.getenv("srvname")
	local pids = route.map[self_srvname]
	local pidlist = db:hkeys(db:key("role","list")) or {}
	print("server all pids:",pidlist,#pidlist)
	for i,v in ipairs(pidlist) do
		pids[tonumber(v)] = true
	end
end

function route.getsrvbypid(pid)
	for srvname,pids in pairs(route.map) do
		if pids[pid] then
			return srvname
		end
	end
	error("pid not map to a server,pid:" .. tostring(pid))
end

function route.addroute(pid,srvname)
	require "script.cluster.clustermgr"
	srvname = srvname or skynet.getenv("srvname")
	route.map[srvname][pid] = true
	for srvname,_ in pairs(clustermgr.connection) do
		xpcall(cluster.call,onerror,servername,"route","addroute",{pid,})
	end
end

function route.delroute(pid,srvname)
	require "script.cluster.clustermgr"
	srvname = srvname or skynet.getenv("srvname")
	local pids = route.map[srvname]
	if pids then
		pids[pid] = nil
	end
	for srvname,_ in pairs(clustermgr.connection) do
		xpcall(cluster.call,onerror,servername,"route","delroute",{pid,})
	end
end

function route.syncto(srvname)
	xpcall(function ()
		local step =- 5000
		local pidlist = route.map[skynet.getenv("srvname")]
		pidlist = keys(pidlist)
		logger.log("debug","route",format("syncto,server(%s->%s) pidlist=%s",skynet.getenv("srvname"),srvname,pidlist))
		for i = 1,#pidlist,step do
			cluster.call(srvname,"route","addroute",slice(pidlist,i,i+step-1))
		end
		cluster.call(srvname,"route","sync_finish")
	end,onerror)
end

local CMD = {}
function CMD.addroute(srvname,pids)
	logger.log("debug","route",format("[CMD] addroute,srvname=%s pids=%s",srvname,pids))
	for _,pid in ipairs(pids) do
		route.addroute(srvname,pid)
	end
end

function CMD.sync_finish(srvname)
	logger.log("debug","route",string.format("[CMD] sync_finish,srvname=%s",srvname))
	route.sync_state[srvname] = true
end

function CMD.delroute(srvname,pids)
	logger.log("debug","route",format("[CMD] delroute,srvname=%s pids=%s",srvname,pids))
	for _,pid in ipairs(pids) do
		route.delroute(srvname,pid)
	end
end

function route.dispatch(srvname,cmd,...)
	local func = assert(CMD[cmd],"[route] Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return route
