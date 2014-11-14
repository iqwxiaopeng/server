require "script.base"
require "script.war"
require "script.war.warmgr"

warsrv = warsrv or {}

function warsrv.init()
	warmgr.init()
end

local CMD = {}
-- warsrvmgr --> warsrv
function CMD.createwar(srvname,profile1,profile2)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	if warmgr.num > 100000 then
		return false
	end
	local war = warmgr.createwar(profile1,profile2)
	warmgr.addwar(war)
	cluster.call(srvname,"war","startwar",profile1.pid,war.warid)
	cluster.call(srvname,"war","startwar",profile2.pid,war.warid)
	war:startwar()
	return true
end

function CMD.query_profile(srvname)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	local profile = {
		num = warmgr.num,
	}
	return profile
end

function CMD.endwar(srvname,pid,warid)
	assert(srvname == "warsrvmgr","Invalid srvname:" .. srvname)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d endwar(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	local enemy_pid = warobj.enemy.pid 
	warmgr.delwar(warid)
	cluster.call(srvname,"war","endwar",pid,warid,2)
	cluster.call(srvname,"war","endwar",enemy_pid,warid,2)
end

-- gamesrv --> warsrv
function CMD.giveupwar(srvname,pid,warid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d giveupwar(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	war:endwar(warobj.enemy)
	warmgr.delwar(war.warid)
	cluster.call("warsrvmgr","war","endwar",pid,war.warid,0)
	cluster.call("warsrvmgr","war","endwar",warobj.enemy.pid,war.warid,1)
end

function CMD.confirm_handcards(srvname,pid,warid,handcards)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d comfirm_handcards(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warobj:confirm_handcards(handcards)
	if warobj.enemy.state == "comfirm_handcards" then
		if warobj.type == "attacker" then
			warobj:beginround()
		else
			warobj.enemy:beginround()
		end
	end
end

function CMD.endround(srvname,pid,warid,roundcnt)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d endround(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warobj:endround(roundcnt)
end

function CMD.playcard(srvname,pid,warid,warcardid)
	local war = warmgr.getwar(warid)
	if not war then
		logger.log("warning","war",string.format("#%d playcard(warid not exists),srvname=%d warid=%d",pid,srvname,warid))
		return
	end
	local warobj = war:getwarobj(pid)
	warobj:playcard(warcardid)
end

function CMD.disconnect(srvname,pid,warid)
end

function warsrv.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return warsrv