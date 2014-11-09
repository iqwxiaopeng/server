local skynet = require "skynet"
require "script.base"
require "script.attrblock.saveobj"
require "script.card.cardcontainer"
require "script.card"
require "script.card.carddb"
require "script.card.cardtablelib"
require "script.db"
require "script.playermgr"
require "script.logger"
require "script.friend.frienddb"
require "script.attrblock.time"

cplayer = class("cplayer",csaveobj,cdatabaseable)

function cplayer:init(pid)
	self.flag = "cplayer"
	csaveobj.init(self,{
		pid = pid,
		flag = self.flag,
	})
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.data = {}
	self.golden_carddb = ccarddb.new{pid = self.pid,flag = "golden",}
	self.wood_carddb = ccarddb.new{pid=self.pid,flag="wood",}
	self.water_carddb = ccarddb.new{pid=self.pid,flag="water",}
	self.fire_carddb = ccarddb.new{pid=self.pid,flag="fire",}
	self.soil_carddb = ccarddb.new{pid=self.pid,flag="soil",}
	self.neutral_carddb = ccarddb.new{pid=self.pid,flag="neutral",}
	self.carddb = ccardcontainer.new{
		golden = self.golden_carddb,
		wood = self.wood_carddb,
		water = self.water_carddb,
		fire = self.fire_carddb,
		soil = self.soil_carddb,
		neutral = self.neutral_carddb,
	}
	self.cardtablelib = ccardtablelib.new(self.pid)
	self.frienddb = cfrienddb.new(self.pid)
	self.today = ctoday.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thistemp = cthistemp.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thisweek = cthisweek.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thisweek2 = cthisweek2.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.timeattr = cattrcontainer.new{
		today = self.today,
		thistemp = self.thistemp,
		thisweek = self.thisweek,
		thisweek2 = self.thisweek2,
	}
	self.autosaveobj = {
		card = self.carddb,
		cardtablelib = self.cardtablelib, 
		friend = self.frienddb,
		time = self.timeattr,
	}

	self.loadstate = "unload"
	self:autosave()
end

function cplayer:save()
	local data = {}
	data.data = self.data
	data.timeattr = self.timeattr:save()
	return data
end

function cplayer:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	self.timeattr:load(data.timeattr)
end

function cplayer:savetodatabase()
	assert(self.pid)
	if self.loadstate == "loaded" then
		local data = self:save()
		db:set(db:key("role",self.pid,"data"),data)
	end
	for k,v in pairs(self.autosaveobj) do
		if v.loadstate == "loaded" then
			db:set(db:key("role",self.pid,k),v:save())
		end
	end
	playermgr.unloadofflineplayer(self.pid)
end

function cplayer:loadfromdatabase(loadall)
	if loadall == nil then
		loadall = true
	end
	assert(self.pid)
	if self.loadstate == "unload" then
		self.loadstate = "loading"
		local data = db:get(db:key("role",self.pid,"data"))
		self:load(data)
		self.loadstate = "loaded"
	end
	if loadall then
		for k,v in pairs(self.autosaveobj) do
			if v.loadstate == "unload" then
				v.loadstate = "loading"
				local data = db:get(db:key("role",self.pid,k))
				v:load(data)
				v.loadstate = "loaded"
			end
		end
	end
end

function cplayer:create(conf)
	assert(conf.name)
	assert(conf.roletype)
	self.loadstate = "loaded"
	self.account = assert(conf.account)
	self.data = {
		name = conf.name,
		roletype = conf.roletype,
		gold = 1000,
		lv = 1,
		viplv = 0,
		createtime = getsecond(),
	}
	self:oncreate()
end

function cplayer:entergame()
	self:onlogin()
	return {result="200 Ok",}
end

-- 正常退出游戏
function cplayer:exitgame()
	self:onlogoff()
	playermgr.delobject(self.pid,"exitgame")
end

-- 掉线处理(正常退出游戏也会走该接口)
function cplayer:disconnect(reason)
	self:savetodatabase()
	self:ondisconnect(reason)
end

local function heartbeat(pid)
	local player = playermgr.getplayer(pid)
	if player then
		timer.timeout("player.heartbeat",120,functor(heartbeat,pid))
		sendpackage(pid,"player","heartbeat")
	end
end

function cplayer:oncreate()
	logger.log("info","register",string.format("register,account=%s pid=%d name=%s roletype=%d lv=%s gold=%d ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:query("lv"),self:getgold(),self:ip()))

	self.frienddb:oncreate(self)
end

function cplayer:onlogin()
	logger.log("info","login",string.format("login,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:query("lv"),self:getgold(),self:ip()))
	local srvobj = globalmgr.getserver()
	heartbeat(self.pid)
	sendpackage(self.pid,"player","resource",{
		gold = self:query("gold",0),
	})
	sendpackage(self.pid,"player","switch",self:query("switch",{
		gm = self:authority() > 0,
		friend = srvobj:isopen("friend"),
	}))
	if srvobj:isopen("friend")	then
		self.frienddb:onlogin(self)
	end
	self:doing("login")
end

function cplayer:onlogoff()

	logger.log("info","login",string.format("logoff,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:query("lv"),self:getgold(),self:ip()))
	local srvobj = globalmgr.getserver()
	if srvobj:isopen("friend")	then
		self.frienddb:onlogin(self)
	end
	self:doing("logoff")
end

function cplayer:ondisconnect(reason)

	logger.log("info","login",string.format("disconnect,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s reason=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:query("lv"),self:getgold(),self:ip(),reason))
end

function cplayer:ondayupdate()
end

function cplayer:onweekupdate()
end

function cplayer:onweek2update()
end

function cplayer:validpay(typ,num,notify)
	local hasnum
	if typ == "gold" then
		hasnum = self:getgold()
	elseif typ == "chip" then
		hasnum = self:getchip()
	else
		error("invalid resource type:" .. tostring(typ))
	end
	if hasnum < num then
		if notify then
			local RESNAME = {
				gold = "金币",
				chip = "chip",
			}
			net.msg.notify(self.pid,string.format("%s不足%d",resname[typ],num))
		end
		return false
	end
	return true
end

function cplayer:addgold(val,reason)
	local oldval = self:getgold()
	local newval = oldval + val
	logger.log("info","resource/gold",string.format("#%d addgold,%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason))
	assert(newval >= 0,string.format("not enough gold:%d+%d=%d",oldval,val,newval))
	self:set("gold",newval)
end

function cplayer:addchip(val,reason)
	local oldval = self:getchip()
	local newval = oldval + val
	logger.log("info","resource/chip",string.format("#%d addchip,%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason))
	assert(newval >= 0,string.format("not enough chip:%d+%d=%d",oldval,val,newval))
	self:set("chip",newval)
end

function cplayer:getcarddbbysid(sid)
	local cardcls = getclassbycardsid(sid)
	local racename = getracename(cardcls.race)
	local carddb = self.carddb:getcarddb_byname(racename)
	return assert(carddb,"Invalid card sid:" .. tostring(sid))
end

function cplayer:getcard(cardid)
	local card,carddb
	for name,_carddb in pairs(self.carddb.data) do
		card = _carddb.getcard(cardid)
		if card then
			carddb = _carddb
			break
		end
	end
	return card
end

function cplayer:doing(what)
	local frdblk = self.frienddb:getfrdblk(self.pid)
	frdblk:set("dogin",what)
end

-- getter
function cplayer:authority()
	if skynet.getenv("mode") == "debug" then
		return 100
	end
	return self:query("auth",0)
end

function cplayer:ip()
	return self.__ip
end

function cplayer:port()
	return self.__port
end

function cplayer:getgold()
	return self:query("gold",0)
end

function cplayer:getchip()
	return self:query("chip",0)
end

-- setter
function cplayer:setauthority(auth)
	self:set("auth",auth)
end


