require "script.base"
require "script.globalmgr"
require "script.cluster"

friendmgr = friendmgr or {}

function friendmgr.init()
	friendmgr.objs = {}
	friendmgr.autosave()
end

local delay = 300
local limit = 100000

function friendmgr.autosave()
	timer.timeout("timer.friendmgr",delay,friendmgr.autosave)
	local cnt = 0
	for pid,frdblk in next(friendmgr.objs,friendmgr.__idx) do
		cnt = cnt + 1
		if cnt > 10000 then
			break
		end
		friendmgr.__idx = pid
		if frdblk:updated() then
			local data = frdblk:save()
			db.set(db.key("friend",pid),data)
		end
	end
end

function friendmgr.loadfrdblk(pid)
	local srvobj = globalmgr.getserver()
	local data
	if srvobj:isfrdsrv() then
		data = db.get(db.key("friend",pid))
	else
		data = cluster.call("frdsrv","friend","query","*")
	end
	local frdblk = cfriend.new(pid)
	frdblk:load(data)
	return frdblk
end

function friendmgr.getfrdblk(pid)
	if not friendmgr.objs[pid] then
		local frdblk = friendmgr.loadfrdblk(pid)
		friendmgr.setfrdblk(pid,frdblk)
	end
	return friendmgr.objs[pid]
end

function friendmgr.setfrdblk(pid,frdblk)
	self.objs[pid] = frdblk
end

function friendmgr.delfrdblk(pid)
	local srvobj = globalmgr.getserver()
	if srvobj:isfrdsrv() then
		--friendmgr.objs[pid] = nil
	else
		friendmgr.objs[pid] = nil
		cluster.call("frdsrv","friend","delref",pid)
	end
end


-- request
local CMD = {}
function CMD.query(srvname,args)
	local pid = assert(args.pid)
	local key = assert(args.key)
	local frdblk = playermgr:getfrdblk(pid)
	frdblk:addref(srvname,true)
	local data = {}
	if key == "*" then
		data = frdblk:save()
	else
		data[key] = frdblk:query(key)
	end
	return data
end

function CMD.delref(srvname,args)
	local pid = assert(args.pid)
	local frdblk = playermgr.getfrdblk(pid)
	frdblk:delref(srvname)
end

function CMD.sync(srvname,args)
	local pid = assert(args.pid)
	local data = assert(args.data)
	local frdblk = self:getfrdblk(pid)
	for k,v in pairs(data) do
		frdblk:set(k,v,true)
	end
	frdblk:sync(data)
end

function friendmgr.dispatch(cmd,...)
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(...)
end

return friendmgr
