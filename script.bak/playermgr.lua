local db = require "script.db"
local logger = require "script.logger"
require "script.attrblock.saveobj"

local playermgr = {}

function playermgr.getobject(id)
	return playermgr.id_obj[id]
end

function playermgr.getplayer(id)
	local obj = playermgr.getobject(id)
	if obj and obj.__type and obj.__type.__name == "cplayer" then
		return obj
	end
end

function playermgr.getobjectbyfd(fd)
	return playermgr.fd_obj[fd]
end

function playermgr.addobject(obj)
	logger.log("info","playermgr","addobject,id=" .. tostring(obj.id))
	local id = obj.id
	assert(playermgr.id_obj[id] == nil,"repeat object id:" .. tostring(id))
	playermgr.id_obj[id] = obj
	playermgr.fd_obj[obj.__fd] = obj
end

function playermgr.delobject(id)
	logger.log("info","playermgr","delobject,id=" .. tostring(id))
	obj = playermgr.id_obj[id]
	playermgr.id_obj[id] = nil
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
	local id1,id2 = obj1.id,obj2.id
	logger.log("info","playermgr",string.format("nettransfer,id1=%s id2=%s",id1,id2))
	local agent = assert(obj1.__agent,"link object havn't agent,id:" .. tostring(id1))
	obj2.__agent = agent
	obj2.__fd = obj1.__fd
	obj2.__ip = obj1.__ip
	obj2.__port = obj1.__port
	
	playermgr.delobject(id1)
	playermgr.addobject(obj2)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	connect.id = id2	
end

function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.id_obj = {}
	playermgr.fd_obj = {}
end
return playermgr
