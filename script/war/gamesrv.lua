require "script.base"

gamesrv = gamesrv or {}

function gamesrv.init()

end

local CMD = {}
-- warsrvmgr --> gamesrv
function CMD.startwar(srvname,typ,pid,warid,matcher_profile)
	if typ == "fight" then
		player:set("fight.warid",warid)
		sendpackage(pid,"war","matchplayer",matcher_profile)
		sendpackage(pid,"war","startwar",{
			warid = warid,
		})
	end
end

function CMD.endwar(srvname,typ,pid,warid,iswin,profile,lastmatch)
	if typ == "fight" then
		player:delete("fight.warid")
		player:unpack_fight_profile(profile)
		sendpackage(pid,"war","warresult",{
			warid = warid,
			iswin = iswin,
		})
	end
end

function gamesrv.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return gamesrv
