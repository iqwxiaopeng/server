local skynet = require "skynet"
require "script.base"
require "script.globalmgr"
require "script.cluster"
require "script.logger"
require "script.cluster"

clustermgr = clustermgr or {}

function clustermgr.init()
	clustermgr.connection = {}
	clustermgr.srvlist = {}
	clustermgr.loadconfig()
	clustermgr.checkserver()
end

-- 载入服务器列表
function clustermgr.loadconfig()
	local config_name = skynet.getenv "cluster"
	local f = assert(io.open(config_name))
	local source = f:read "*a"
	f:close()
	local tmp = {}
	assert(load(source, "@"..config_name, "t", tmp))()
	clustermgr.srvlist = tmp
	pprintf("srvlist:%s",clustermgr.srvlist)
end

function clustermgr.checkserver()
	timer.timeout("clustermgr.checkserver",60,clustermgr.checkserver)
	local srvobj = globalmgr.getserver()
	for srvname,_ in pairs(clustermgr.srvlist) do
		if srvname ~= srvobj.servername then
			local ok,result = pcall(cluster.call,srvname,"cluster","heartbeat",1)
			if not ok then
				clustermgr.connection[srvname] = nil
				logger.log("critical","err",string.format("server(%s) lost connect",srvname))
			end
		end
	end
end

function clustermgr.isconnect(srvname)
	return clustermgr.connection[srvname]
end

-- request
local CMD = {}
function CMD.heartbeat(srvname)
	return true
end

function clustermgr.dispatch(srvname,cmd,...)
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))	
	return func(srvname,...)
end

return clustermgr
