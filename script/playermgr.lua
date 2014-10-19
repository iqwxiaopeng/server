require "script.db"
logger = require "script.logger"

local playermgr = {}

function playermgr.getobject(id)
	return playermgr.objs[id]
end

function playermgr.getplayer(id)
	local obj = playermgr.getobject(id)
	if obj and obj.__type and obj.__type.__name == "cplayer" then
		return obj
	end
end

function playermgr.addobject(obj)
	logger.log("info","playermgr","addobject,id=" .. tostring(obj.id))
	local id = obj.id
	assert(playermgr.objs[id] == nil,"repeat object id:" .. tostring(id))
	playermgr.objs[id] = obj
end

function playermgr.delobject(id)
	logger.log("info","playermgr","delobject,id=" .. tostring(id))
	obj = playermgr.objs[id]
	playermgr.objs[id] = nil
	if obj and obj.__type and obj.__type.__name == "cplayer" then
		obj:disconnect()
	end
end

function playermgr.createplayer()
	require "script.player"
	local pid = db.get(db.key("role","maxroleid"))
	pid = pid + 1
	assert(db.get(db.key("role",pid)),"maxroleid error")
	db.set(db.key("role","maxroleid"),pid)
	logger.log("info","account",string.format("createplayer, pid=%d",pid))
	local player = cplayer.new(pid)
	player:create()
	player:nowsave()
	return player
end

function playermgr.recoverplayer(pid)
	require "script.player"	
	local player = clayer.new(pid)
	player:loadfromdatabase()
	return player
end

function playermgr.nettransfer(id1,id2)
	logger.log("info","playermgr",string.format("nettransfer,id1=%s id2=%s",id1,id2))
	local proto = require "script.proto"
	local obj1 = assert(playermgr.getobject(id1))
	local obj2 = assert(playermgr.getobject(id2))
	local agent = assert(obj1.__agent,"link object havn't agent,id:" .. tostring(id1))
	obj2.__agent = agent
	obj2.__fd = obj1.__fd
	obj2.__ip = obj1.__ip
	obj1.__agent = nil
	obj1.__fd = nil
	obj1.__ip = nil
	playermgr.delobject(id1)
	playermgr.addobject(id2)
	agent.id = assert(obj2.id)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	connect.id = id2	
end

function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.objs = {}
	playermgr.players = {}
end
return playermgr
