local skynet = require "skynet"
require "script.base"
require "script.attrblock.saveobj"
require "script.card.cardcontainer"
require "script.card"
require "script.card.carddb"
require "script.db"
require "script.playermgr"
require "script.logger"

cplayer = class("cplayer",csaveobj,cdatabaseable)

function cplayer:init(pid)
	local flag = "cplayer"
	csaveobj.init(self,{
		pid = pid,
		flag = flag,
	})
	cdatabaseable.init(self,{
		pid = pid,
		flag = flag,
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
	self.autosaveobj = {
		card = self.carddb,
	}

	self.loadstate = "unload"
	self:autosave()
end

function cplayer:save()
	local data = {}
	data.data = self.data
	return data
end

function cplayer:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
end

function cplayer:savetodatabase()
	assert(self.pid)
	if self.loadstate ~= "loaded" then
		return
	end
	local data = self:save()
	db.set(db.key("role",self.pid,"data"),data)
	for k,v in pairs(self.autosaveobj) do
		db.set(db.key("role",self.pid,k),v:save())
	end
end

function cplayer:loadfromdatabase()
	assert(self.pid)
	if self.loadstate ~= "unload" then
		return
	end
	self.loadstate = "loading"
	local data = db.get(db.key("role",self.pid,"data"))
	self:load(data)
	for k,v in pairs(self.autosaveobj) do
		local data = db.get(db.key("role",self.pid,k))
		v:load(data)
	end
	self.loadstate = "loaded"
end

function cplayer:create(conf)
	assert(conf.name)
	assert(conf.roletype)
	self.account = assert(conf.account)
	self.data = {
		name = conf.name,
		roletype = conf.roletype,
		gold = 1000,
		viplv = 0,
		createtime = getsecond(),
	}
	self:oncreate()
end

function cplayer:entergame()
	self:onlogin()
	return {result="200 Ok",}
end

function cplayer:exitgame()
	self:onlogoff()
	self:disconnect("exitgame")
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
	logger.log("info","register",string.format("register,account=%s pid=%d name=%s roletype=%d gold=%d ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:getgold(),self:ip()))
end

function cplayer:onlogin()
	logger.log("info","login",string.format("login,account=%s pid=%s name=%s roletype=%s gold=%s ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:getgold(),self:ip()))
	heartbeat(self.pid)
	sendpackage(self.pid,"player","resource",{
		gold = self:query("gold",0),
	})
	sendpackage(self.pid,"player","switch",self:query("switch",{}))
end

function cplayer:onlogoff()
	logger.log("info","login",string.format("logoff,account=%s pid=%s name=%s roletype=%s gold=%s ip=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:getgold(),self:ip()))
end

function cplayer:ondisconnect(reason)
	logger.log("info","login",string.format("disconnect,account=%s pid=%s name=%s roletype=%s gold=%s ip=%s reason=%s",self.account,self.pid,self:query("name"),self:query("roletype"),self:getgold(),self:ip(),reason))
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
	else
		error("invalid resource type:" .. tostring(typ))
	end
	if hasnum < num then
		if notify then
			local RESNAME = {
				gold = "金币",
			}
			net.msg.notify(self,string.format("%s不足%d",resname[typ],num))
		end
		return false
	end
	return true
end

function cplayer:addgold(val,reason)
	local oldval = self:getgold()
	local newval = oldval + val
	logger.log("info","resource/gold","#%d addgold,%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason)
	self:set("gold",math.max(0,newval))
	assert(newval >= 0,string.format("not enough gold:%d+%d=%d",oldval,val,newval))
end

function cplayer:addcardbysid(sid,amount)
	local cardcls = ccard.getclassbysid(sid)
	local racename = getracename(cardcls.race)
	local carddb = self.carddb:getcarddb_byname(racename)
	carddb:addcardbysid(sid,amount)
end

function cplayer:delcardbysid(sid,amount)
	local cardcls = ccard.getclassbysid(sid)
	local racename = getracename(cardcls.race)
	local carddb = self.carddb:getcarddb_byname(racename)
	if carddb:getamountbysid(sid) < amount then
		return false
	end
	carddb:delcardbysid(sid,amount)
	return true
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

-- setter
function cplayer:setauthority(auth)
	self:set("auth",auth)
end


