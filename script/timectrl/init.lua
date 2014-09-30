require "gamelogic.base"
require "adapterlib.gametimer"
require "gamelogic.npc.npcmgr"
require "gamelogic.serverinfo"
require "gamelogic.arenamanager"

timectrl = {}
local INTERVAL = 5 --5 minute

function timectrl.next_fiveminute(now)
	now = now or getsecond()
	local secs = now + INTERVAL * 60
	local min = gethourminute(secs)	
	min = math.floor(min/INTERVAL) * INTERVAL
	local tm = {year=getyear(secs),month=getyearmonth(secs),day=getmonthday(secs),hour=getdayhour(secs),min=min,sec=0,}
	print(self_tostring(tm),min)
	return os.time(tm)
end

function timectrl.starttimer()
	local now = getsecond()
	local next_time = timectrl.next_fiveminute(now)	
	assert(next_time > now,string.format("%d > %d",next_time,now))
	g_gametimer:timeout(timectrl.fiveminute_update,next_time-now,"timectrl.timer")
end

function timectrl.main(...)
	g_serverinfo:logger("timectrl","timectrl.main")
	timectrl.starttimer()
end

function timectrl.fiveminute_update()
	timectrl.starttimer() 
	timectrl.onfiveminuteupdate()
	now = getsecond()
	local min = gethourminute(now)
	if min % 10 == 0 then
		timectrl.tenminute_update()
	end
end

function timectrl.tenminute_update(now)
	timectrl.ontenminuteupdate()
	local min = gethourminute(now)
	if min == 0 or min == 30 then
		timectrl.halfhour_update()
	end
end

function timectrl.halfhour_update(now)
	timectrl.onhalfhourupdate()
	local min = gethourminute(now)
	if min == 0 then
		timectrl.hour_update(now)
	end
end

function timectrl.hour_update(now)
	timectrl.onhourupdate()
	local hour = getdayhour(now)
	if hour == 0  then
		timectrl.day_update()
	end
end

function timectrl.day_update(now)
	timectrl.ondayupdate()
	local weekday = getweekday(now)
	if weekday == 0 then
		timectrl.week2_update(now)
	elseif weekday == 1 then
		timectrl.week_update(now)
	end
	local day = getmonthday(now)
	if day == 1 then
		timectrl.month_update()
	end
end

function timectrl.week_update(now)
	timectrl.onweekupdate()
end

function timectrl.week2_update(now)
	timectrl.onweek2update()
end

function timectrl.month_update(now)
	timectrl.onmonthupdate()
end

function timectrl.error_handle(...)
	args = {...}
	g_serverinfo:logger("timectrl",string.format("[ERROR] %s",self_tostring(args)))
	print(debug.traceback())
end

function timectrl.onfiveminuteupdate()
	g_serverinfo:logger("timectrl","onfiveminuteupdate")
	local npc_keju = npcmgr.getnpc("keju")
	xpcall(functor(npc_keju.onfiveminuteupdate,npc_keju),timectrl.error_handle)
end

function timectrl.ontenminuteupdate()
	g_serverinfo:logger("timectrl","ontenminuteupdate")
end

function timectrl.onhalfhourupdate()
	g_serverinfo:logger("timectrl","onhalfhourupdate")
end


function timectrl.onhourupdate()
	g_serverinfo:logger("timectrl","onhourupdate")
	local playermgr = g_serverinfo.playermanager
	for pid in pairs(playermgr:AllPlayerID()) do
		local playerObj = playermgr:GetPlayer(pid)
		if playerObj then
			xpcall(functor(playerObj.onmonthupdate,playerObj),timectrl.error_handle)
		end
	end
end

function timectrl.ondayupdate()
	g_serverinfo:logger("timectrl","ondayupdate")
	local playermgr = g_serverinfo.playermanager
	for pid in pairs(playermgr:AllPlayerID()) do
		local playerObj = playermgr:GetPlayer(pid)
		if playerObj then
			xpcall(functor(playerObj.ondayupdate,playerObj),timectrl.error_handle)
		end
	end
	xpcall(g_arenamanager.ondayupdate,timectrl.error_handle)
end

function timectrl.onweekupdate()
	g_serverinfo:logger("timectrl","onweekupdate")
	local playermgr = g_serverinfo.playermanager
	for pid in pairs(playermgr:AllPlayerID()) do
		local playerObj = playermgr:GetPlayer(pid)
		if playerObj then
			xpcall(functor(playerObj.onweekupdate,playerObj),timectrl.error_handle)
		end
	end
end

function timectrl.onweek2update()
	g_serverinfo:logger("timectrl","onweek2update")
	local playermgr = g_serverinfo.playermanager
	for pid in pairs(playermgr:AllPlayerID()) do
		local playerObj = playermgr:GetPlayer(pid)
		if playerObj then
			xpcall(functor(playerObj.onweek2update,playerObj),timectrl.error_handle)
		end
	end
end

function timectrl.onmonthupdate()
	local playermgr = g_serverinfo.playermanager
	for pid in pairs(playermgr:AllPlayerID()) do
		local playerObj = playermgr:GetPlayer(pid)
		if playerObj then
			xpcall(functor(playerObj.onmonthupdate,playerObj),timectrl.error_handle)
		end
	end
end


return timectrl
