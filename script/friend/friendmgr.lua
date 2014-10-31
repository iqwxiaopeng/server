require "script.base"
require "script.globalmgr"
require "script.cluster"
require "script.logger"
require "script.attrblock.saveobj"

friendmgr = friendmgr or {}

function friendmgr.init()
	friendmgr.objs = {}
	--friendmgr.autosave()
end

-- todo: delete
local delay = 300
local limit = 100000

function friendmgr.autosave()
	timer.timeout("timer.friendmgr",delay,friendmgr.autosave)
	print(friendmgr.objs,friendmgr.__idx)
	local cnt = 0
	for pid,frdblk in next,friendmgr.objs,friendmgr.__idx do
		cnt = cnt + 1
		if cnt > limit then
			break
		end
		friendmgr.__idx = pid
		if frdblk:updated() then
			local data = frdblk:save()
			db:set(db:key("friend",pid),data)
		end
	end
	if cnt < limit then
		friendmgr.__idx = nil
	end
end

function friendmgr.loadfrdblk(pid)
	require "script.friend"
	local frdblk = cfriend.new(pid)
	frdblk:loadfromdatabase()
	return frdblk
end

function friendmgr.getfrdblk(pid)
	if not friendmgr.objs[pid] then
		local frdblk = friendmgr.loadfrdblk(pid)
		friendmgr.addfrdblk(pid,frdblk)
	end
	return friendmgr.objs[pid]
end

function friendmgr.addfrdblk(pid,frdblk)
	friendmgr.objs[pid] = frdblk
	add_saveobj(frdblk)
end

function friendmgr.delfrdblk(pid)
	local frdblk = friendmgr.objs[pid]
	friendmgr.objs[pid] = nil
	if frdblk then
		del_saveobj(frdblk)
		if cserver.isfrdsrv() then
		else
			cluster.call("frdsrv","friend","delref",pid)
		end
	end
end


-- request
local CMD = {}
function CMD.query(srvname,pid,key)
	local frdblk = friendmgr.getfrdblk(pid)
	frdblk:addref(srvname)
	local data = {}
	if key == "*" then
		data = frdblk:save()
	else
		data[key] = frdblk:query(key)
	end
	logger.log("debug","friendmgr",string.format("%s query,pid=%d key=%s data=%s",srvname,pid,key,data))
	return data
end

function CMD.delref(srvname,pid)
	logger.log("debug","friendmgr",string.format("%s delref,pid=%d",srvname,pid))
	local frdblk = friendmgr.getfrdblk(pid)
	frdblk:delref(srvname)
end

function CMD.sync(srvname,pid,data)
	logger.log("debug","friendmgr",string.format("%s sync,pid=%d data=%s",srvname,pid,data))
	local frdblk = friendmgr.getfrdblk(pid)
	for k,v in pairs(data) do
		frdblk:set(k,v,true)
	end
	if frdblk.loadnull then
		frdblk.loadnull = nil
		frdblk:nowsave()
	end
	frdblk:sync(data)
end

function friendmgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return friendmgr
