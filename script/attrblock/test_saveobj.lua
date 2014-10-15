require "gamelogic.base"
require "gamelogic.base.class_new"
require "gamelogic.base.databaseable_new"
require "gamelogic.attrblock.saveobj"
require "adapterlib.gamedb"
local skynet = require "skynet"

cperson = class_new("cperson",csaveobj,ccdatabaseable)
function cperson:init(conf)
	csaveobj.init(self,conf)
	ccdatabaseable.init(self,conf)
	self.data = {}
end

function cperson:save()
	local data = {}
	data.data = self.data
	return data
end

function cperson:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function cperson:savedatabase()
	csaveobj.savedatabase(self)
	local data = self:save()
	g_gamedb:gdbUpdate("test","person",data)
end

cmoney = class_new("cmoney",csaveobj,ccdatabaseable)
function cmoney:init(conf)
	csaveobj.init(self,conf)
	ccdatabaseable.init(self,conf)
	self.data = {}
end

function cmoney:save()
	local data = {}
	data.data = self.data
	return data
end

function cmoney:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function cmoney:savedatabase()
	csaveobj.savedatabase(self)
	local data = self:save()
	g_gamedb:gdbUpdate("test","money",data)
end

function test()
	local person = cperson.new{
			id = 1,
			flag = "person",
		}
	local money = cmoney.new{
			id = 1,
			flag = "money",
		}
	person:set("key1","hello,world")
	money:set("key1","haha")
	person:nowsave()	-- cann't save
	person:autosave()
	money:oncesave()
	person:merge(money)
	person:nowsave()	--money also save
	person:nowsave()	-- money not save
	print(pcall(person.oncesave,person))
	person:clearsaveflag()
	person:oncesave()
	skynet.sleep(12)	-- occr one save
	person:set("key2","goodidea")
	person:oncesave()
end

-- test()