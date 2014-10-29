require "script.base"
require "script.globalmgr"
require "script.friend.friendmgr"
require "cluster.cluster.clustermgr"

cfriend = class("cfriend",cdatabaseable)

function cfriend:init(pid)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "cfriend",
	})
	self.refs = {}
	self.data = {}
end

function cfriend:load(data)
	if not data or not next(data) then
		self:onloadnull()
		return
	end
	self.data = data
end

function cfriend:save()
	return self.data
end

function cfriend:onloadnull()
	self:create()
end

function cfriend:create()
	local srvobj = globalmgr.getserver()
	if srvobj:isgamesrv() then
		local player = playermgr.getplayer(self.pid)
		if player then
		else
			player = playermgr.loadofflineplayer(self.pid)
		end
		self.data = {
			lv = player:query("lv"),
			name = player:query("name"),
			roletype = player:query("roletype"),
			srvname = srvobj.servername,
		}
		self:sync(self:save())
	end
end

-- 为了简化操作，ref只统计谁引用过我，而不记录引用次数，这样对于玩家，可以在上线，增加好友/申请者时增加引用，下线，删除好友/申请者时减少引用
function cfriend:addref(arg)
	if (type(arg) ~= "number" and not  clustermgr.srvlist[arg]) then
		error("addref invalid arg:" .. tostring(arg))
	end
	self.refs[arg] = 1
end

function cfriend:delref(arg)
	self.refs[arg] = nil
	if not next(self.refs) then
		friendmgr.delfrdblk(self.pid)
	end
end


function cfriend:set(key,val,notsync)
	cdatabaseable.set(self,key,val)
	if not notsync then
		self:sync({[key] = val,})
	end
end

function cfriend:sync(data)
	local srvobj = globalmgr.getserver()
	if srvobj:isfrdsrv() then
		for srvname,_ in pairs(self.refs) do
			if srvname ~= self:query("srvname") then
				cluster.call(srvname,"friend","sync",{pid=self.pid,data=data})
			end
		end
	elseif srvobj:isgamesrv() then
		-- 及时同步
		if srvobj.servername == self:query("srvname") then
			cluster.call("frdsrv","friend","sync",{pid=self.pid,data=data,})
		end
		for pid,_ in pairs(self.refs) do
			if pid ~= self.pid then
				sendpackage(pid,"friend","sync",data)
			end
		end
	end
end

return cfriend
