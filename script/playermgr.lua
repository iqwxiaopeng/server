require "script.db"

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
	local id = obj.id
	assert(playermgr.objs[id] ~= nil,"repeat object id:" .. tostring(id))
end

function playermgr.delobject(id)
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
	local obj1 = assert(playermgr.getobject(id1))
	local obj2 = assert(playermgr.getobject(id2))
	local agent = assert(obj1.__agent,"link object havn't agent,id:" .. tostring(id1))
	obj1.__agent = nil
	obj2.__agent = agent
	agent.id = assert(obj2.id)
	playermgr.delobject(id1)
	playermgr.addobject(id2)
end

function playermgr.init()
	playermgr.objs = {}
	playermgr.players = {}
end
return playermgr
