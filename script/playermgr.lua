local db = require "script.db"
local logger = require "script.logger"
require "script.attrblock.saveobj"

local playermgr = {}

function playermgr.getobject(pid)
	return playermgr.id_obj[pid]
end

function playermgr.getplayer(pid)
	local obj = playermgr.getobject(pid)
	if obj and obj.__type and obj.__type.__name == "cplayer" then
		return obj
	end
end

function playermgr.getobjectbyfd(fd)
	return playermgr.fd_obj[fd]
end

function playermgr.addobject(obj)
	logger.log("info","playermgr","addobject,pid=" .. tostring(obj.pid))
	local pid = obj.pid
	assert(playermgr.id_obj[pid] == nil,"repeat object pid:" .. tostring(pid))
	playermgr.id_obj[pid] = obj
	playermgr.fd_obj[obj.__fd] = obj
end

function playermgr.delobject(pid)
	logger.log("info","playermgr","delobject,pid=" .. tostring(pid))
	obj = playermgr.id_obj[pid]
	playermgr.id_obj[pid] = nil
	if obj then
		playermgr.fd_obj[obj.__fd] = nil
		if obj.__saveobj_flag then
			del_saveobj(obj)
		end
		if obj.__type and obj.__type.__name == "cplayer" then
			obj:disconnect("diconnect")
		end
	end
end

function playermgr.createplayer()
	require "script.player"
	local pid = db.get(db.key("role","maxroleid"),10000)
	pid = pid + 1
	assert(not db.get(db.key("role",pid)),"maxroleid error")
	db.set(db.key("role","maxroleid"),pid)
	logger.log("info","account",string.format("createplayer, pid=%d",pid))
	local player = cplayer.new(pid)
	return player
end

function playermgr.recoverplayer(pid)
	assert(tonumber(pid),"invalid pid:" .. tostring(pid))
	require "script.player"	
	local player = cplayer.new(pid)
	player:loadfromdatabase()
	return player
end

function playermgr.nettransfer(obj1,obj2)
	local proto = require "script.proto"
	local id1,id2 = obj1.pid,obj2.pid
	logger.log("info","playermgr",string.format("nettransfer,id1=%s id2=%s",id1,id2))
	local agent = assert(obj1.__agent,"link object havn't agent,pid:" .. tostring(id1))
	obj2.__agent = agent
	obj2.__fd = obj1.__fd
	obj2.__ip = obj1.__ip
	obj2.__port = obj1.__port
	
	playermgr.delobject(id1)
	playermgr.addobject(obj2)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	connect.pid = id2	
end

function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.id_obj = {}
	playermgr.fd_obj = {}
end
return playermgr
