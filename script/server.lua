local skynet = require "skynet"
require "script.base"
require "script.attrblock.saveobj"
require "script.logger"
require "script.db"

cserver = class("cserver",cdatabaseable,csaveobj)

function cserver:init()
	self.flag = "cserver"
	cdatabaseable.init(self,{
		pid = 0,
		flag = self.flag,
	})
	csaveobj.init(self,{
		pid = 0,
		flag = self.flag,
	})
	self.loadstate = "unload"
	self:autosave()

	self.servername = skynet.getenv("servername")
	self.serverid = skynet.getenv("serverid")
	self.data = {}
	logger.log("info","server","init")
end

function cserver:create()
	logger.log("info","server","create")
	self.data = {
		createday = getdayno(),
	}
end

function cserver:save()
	local data = {}
	data.data = self.data
	return data
end

function cserver:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
end

function cserver:savetodatabase()
	if self.loadstate == "loaded" then
		return
	end
	local data = self:save()
	db.set(db.key("global","server"),data)
end

function cserver:loadfromdatabase()
	if self.loadstate ~= "unload" then
		return
	end
	self.loadstate = "loading"
	local data = db.get(db.key("global","server"))
	if data == nil then
		self:create()
	else
		self:load(data)
	end
	self.loadstate = "loaded"
end


-- getter
function cserver:getopenday()
	return getdayno() - self:query("createday") + self:query("openday")
end

function cserver:addopenday(val,reason)
	logger.log("info","server",string.format("addopenday,val=%d reason=%s",val,reason))
	self:add("openday",val)
end

return cserver
