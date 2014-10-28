require "script.base"
require "script.globalmgr"
require "script.friend.friendmgr"

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
		return
	end
	self.data = data
end

function cfriend:save()
	return self.data
end

function cfriend:addref(arg,notcount)
	if notcount then
		self.refs[arg] = 1
	else
		if not self.refs[arg] then
			self.refs[arg] = 0
		end
		self.refs[arg] = self.refs[arg] + 1
	end

end

function cfriend:delref(arg)
	self.refs[arg] = self.refs[arg] - 1
	if self.refs[arg] <= 0 then
		self.refs[arg] = nil
	end
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
				cluster.call(srvname,"friend","sync",data)
			end
		end
	elseif srvobj:islogicsrv() then
		for pid,_ in pairs(frdobj.refs) do
			sendpackage(pid,"friend","sync",data)
		end
	end
end

return cfriend
