local playermgr = {}

function playermgr.getobject(id)
	return playermgr.objs[id]
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

function playermgr.init()
	playermgr.objs = {}
	playermgr.players = {}
end
return playermgr
