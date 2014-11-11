require "script.base"

warsrvmgr = warsrvmgr or {}

function warsrvmgr.init()
	warsrvmgr.warsrvs = {}
	warsrvmgr.order_warsrv = {}
	warsrvmgr.lv_profiles = {}
	warsrvmgr.pid_profile = {}
end

-- 分配定时器
function warsrvmgr.allocer()
	timer.timeout("warsrvmgr.allocer",1,warsrvmgr.allocer)
	for lv,profiles in pairs(self.lv_profiles) do
		local profile1,profile2
		for _,profile in ipairs(profiles) do
			if profile.state == "ready" then
				if not profile1 then
					profile1 = profile
				else
					profile2 = profile
					break
				end
			end
		end
		if ishit(50,100) then
			profile1.isattacker = true
		else
			profile1,profile2 = profile2,profile1
			profile1.isattacker = true
		end
		profile1.state = "match"
		profile2.state = "match"
		warsrvmgr.onmatch(profile1,profile2)
		for _,warsrvname in ipairs(warsrvmgr.order_warsrv) do
			local result = cluster.call(warsrvname,"war","createwar",profile1,profile2)
			if result then
				break
			end
		end
	end
end

function warsrvmgr.onmatch(profile1,profile2)
	profile1.lastmatch = profile2.pid
	profile2.lastmatch = profile1.pid

end


function warsrvmgr.addprofile(profile)
	local pid = assert(profile.pid)
	local lv = assert(profile.lv)
	profile.state = "ready"
	self.pid_profile[pid] = profile
	if not self.lv_profiles[lv] then
		self.lv_profiles[lv] = {}
	end
	table.insert(self.lv_profiles[lv],profile)
	profile.pos = #self.lv_profiles[lv]
end

function warsrvmgr.delprofile(pid)
	local profile = warsrvmgr.getprofile(pid)
	if profile then
		self.pid_profile[pid] = nil
		local pos = profile.pos
		table.remove(self.lv_profiles[profile.lv],pos)
	end
end

function warsrvmgr.getprofile(pid)
	return self.pid_profile[pid]
end

function warsrvmgr.startwar(pid,warid)
	local profile = warsrvmgr.getprofile(pid)
	profile.state = "startwar"
	local matcher_profile = warsrvmgr.getprofile(profile.lastmatch)
	if matcher_profile then
		cluster.call(profile.srvname,"war","startwar","fight",pid,warid,matcher_profile)
	end
end

function warsrvmgr.endwar(pid,warid,iswin)
	local profile = warsrvmgr.getprofile(pid)
	profile.state = "endwar"
	if iswin then
		profile.wincnt = profile.wincnt + 1
		profile.consecutive_wincnt = profile.consecutive_wincnt + 1
		profile.consecutive_failcnt = 0
	else
		profile.failcnt = profile.failcnt + 1
		profile.consecutive_failcnt = profile.consecutive_failcnt + 1
		profile.consecutive_wincnt = 0
	end
	lastmatch = warsrvmgr.getprofile(profile.lastmatch)
	cluster.call(profile.srvname,"war","endwar","fight",pid,warid,iswin,profile,lastmatch)	
end


local CMD = {}

-- gamesrv --> warsrvmgr
function CMD.search_opponent(srvname,player_profile)
	warsrvmgr.addprofile(player_profile)
end

function CMD.cancel_match(srvname,pid)
	warsrvmgr.delprofile(pid)
end

-- warsrv --> warsrvmgr
function CMD.startwar(srvname,pid)
	assert(cserver.iswarsrv(srvname),"Not a warsrv:" .. tostring(srvname))
	warsrvmgr.startwar(pid)
end


function CMD.endwar(srvname,pid,iswin)
	assert(cserver.iswarsrv(srvname),"Not a warsrv:" .. tostring(srvname))
	warsrvmgr.endwar(pid,iswin)
end


function CMD.warsrv_profile(srvname,profile)
	assert(cserver.iswarsrv(srvname),"Not a warsrv:" .. tostring(srvname))
	warsrvmgr.warsrvs[srvname] = profile
	for srvname,profile in pairs(warsrvmgr.warsrvs) do
		table.insert(warsrvmgr.order_srvname,srvname)
	end
	sort(warsrvmgr.order_srvname,function (v1,v2)
		return v1.num < v2.num
	end)
end


function warsrvmgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return warsrvmgr
