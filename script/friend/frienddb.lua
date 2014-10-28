require "script.base"
require "script.logger"

cfrienddb = class("cfrienddb",cdatabaseable)

function cfrienddb:init(pid)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "cfrienddb",
	})
	self.frdlist = {}
	self.applyerlist = {}
	self.applyerlimit = 20
	self.frdlimit = 60
	self.data = {}
end

function cfrienddb:save()
	local data = {}
	data.frdlist = self.frdlist
	data.applyerlist = self.applyerlist
	data.data = self.data
	return data
end

function cfrienddb:load(data)
	if not data or not next(data) then
		return
	end
	self.frdlist = data.frdlist
	self.applyerlist = data.applyerlist
	self.data = data.data
end

function cfrienddb:savetodatabase()
	if self.loadstate ~= "loaded" then
		return
	end
	local data = self:save()
	db.set(db.key("friend",self.pid),data)
end

function cfrienddb:loadfromdatabase()
	if self.loadstate ~= "unload" then
		return
	end
	self.loadstate = "loading"
	local data = db.get(db.key("friend",self.pid))
	self:load(data)
	for _,pid in ipairs(self.frdlist) do
		self:getfrdblk(pid)
	end
	for _,pid in ipairs(self.applyerlist) do
		self:getfrdblk(pid)
	end
	self.loadstate = "loaded"
end

function cfrienddb:onlogin(player)
	for _,pid in ipairs(self.frdlist) do
		local frdblk = self:getfrdblk(pid)
		net.friend.sync(self.pid,frdblk:save())
	end
	net.friend.addlist(self.pid,"friend",self.frdlist)
	for _,pid in ipairs(self.applyerlist) do
		local frdblk = self.getfrdblk(pid)
		net.friend.sync(self.pid,frdblk:save())
	end
	local applyercnt = self:query("applyercnt",0)
	net.friend.addlist(self.pid,"applyer",slice(self.applyerlist,1,applyercnt))
	local new_applyerlist = slice(self.applyerlist,applyerlist+1,#self.applyerlist)
	if #new_applyerlist > 0 then
		net.friend.addlist(self.pid,"applyer",new_applyerlist,true)
	end
end

function cfrienddb:onlogoff(player)
	for _,pid in ipairs(self.frdlist) do
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
	end
	for _,pid in ipairs(self.applyerlist) do
		local frdblk = self:getfrdblk()
		frdblk:delref(self.pid)
	end
end

function cfrienddb:getfrdblk(pid)
	return friendmgr.getfrdblk(pid)
end

function cfrienddb:addapplyer(pid)
	if #self.applyerlist >= self:getapplyerlimit() then
		self:delapplyer(self.applyerlist[1])
	end
	logger.log("info","friend",string.format("#%d addapplyer,pid=%d",self.pid,pid))
	table.insert(self.applyerlist,pid)
	local frdblk = self:getfrdblk(pid)
	frdblk:addref(pid)
	net.friend.sync(self.pid,frdblk:save())
	net.friend.addlist(self.pid,"applyer",pid,true)
end

function cfrienddb:delapplyer(pid,notdelref)
	logger.log("info","friend",string.format("#%d delapplyer,pid=%d",self.pid,pid))
	local pos = findintable(self.applyerlist,pid)
	if not pos then
	else
		table.remove(self.applyerlist,pos)
		local frdblk = self:getfrdblk(pid)
		if not notdelref then
			frdblk:delref(self.pid)
		end
	end
	net.friend.dellist(self.pid,"applyer",pid)
end

function cfrienddb:addfriend(pid,notaddref)
	if #self.frdlist >= self:getfriendlimit() then
		net.msg.notify(self.pid,"好友个数已达上限")
		return
	end
	self:delapplyer(pid,true)
	logger.log("info","friend",string.format("#%d addfriend %d",self.pid,pid))
	table.insert(self.frdlist,pid)
	local frdblk = self:getfrdblk(pid)
	if not notaddref then
		frdblk:addref(self.pid)
	end
	net.friend.sync(self.pid,frdblk:save())
	net.friend.addlist(self.pid,"friend",pid,true)
end

function cfrienddb:delfriend(pid)
	logger.log("info","friend",string.format("#%d delfriend %d",self.pid,pid))
	local pos = findintable(self.frdlist,pid)
	if not pos then
	else
		table.remove(self.frdlist,pos)
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
	end
	net.friend.dellist(self.pid,"friend",pid)	
end

function cfriend:apply_addfriend(pid)
	logger.log("info","friend",string.format("#%d apply_addfriend %d",self.pid,pid))
	local toapplylist,exceedtime = self.thistemp("toapplylist")
	local pos = findintable(self.applyerlist)
	if pos then
		net.msg.notify(self.pid,"您的申请已经发出")
		return
	end
	table.insert(toapplylist,pid)
	self.thistemp:set("toapplylist",toapplylist,300)
	net.friend.addlist(self.pid,"toapply",pid,true)	
	local target = playermgr.getplayer(pid)
	if target then
		target.frienddb:addapplyer(self.pid)
	else
		target = playermgr.loadofflineplayer(pid)
		target.frienddb:addapplyer(self.pid)
	end
end

-- getter
function cfrienddb:getfriendlimit()
	return self.frdlimit + self:query("extfrdlimit",0)
end

function cfriend:getapplyerlimit()
	return self.applyerlimit
end

return cfrienddb
