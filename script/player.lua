require "script.base"
require "attrblock.saveobj"
local timer = require "script.timer"

cplayer = class("cplayer",csaveobj,cdatabaseable)

function cplayer:init(id)
	local flag = "cplayer"
	csaveobj.init(self,{
		id = id,
		flag = flag,
	})
	cdatabaseable.init(self,{
		id = id,
		flag = flag,
	})
	self.data = {}
	self:autosave()
end

function cplayer:save()
	local data = {}
	data.data = self.data
end

function cplayer:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function cplayer:savetodatabase()
	local data = self:save()
	db.set(db.key("role",self.id,"data"),data)
end

function cplayer:loadfromdatabase()
	local data = db.get(db.key("role",self.id,"data"))
	self:load(data)
end

function cplayer:entergame()
	self:onlogin()
	return "200 Ok"
end

function cplayer:exitgame()
	self:onlogoff()
end

function cplayer:disconnect()
end

local function heartbeat(id)
	local player = playermgr.getplayer(id)
	if player then
		timer.timeout("player.heartbeat",60,functor(heartbeat,id))
		sendpackage(id,"player","heartbeat")
	end
end

function cplayer:onlogin()
	logger.log("info",string.format("login,pid=%d gold=%d ip=%s",self.id,self:query("gold",0),self:ip()))
	heartbeat(self.id)
	sendpackage(self.id,"player","resource",{
		gold = self:query("gold",0),
	})
	sendpackage(self.id,"player","switch",self:query("switch",{}))
end

function cplayer:onlogoff()
	logger.log("info",string.format("logoff,pid=%d gold=%d ip=%s",self.id,self:query("gold",0),self:ip()))
end

function cplayer:ondisconnect()
end

function cplayer:ondayupdate()
end

function cplayer:onweekupdate()
end

function cplayer:onweek2update()
end


function cplayer:ip()
	return string.match(self.__ip,"(.*):.*")
end

function cplayer:port()
	return string.match(self.__ip,".*:(.*)")
end
