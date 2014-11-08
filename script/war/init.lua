require "script.base"

--- 1. player ready
--- 2. startwar
--- 3. loopround
--- 4. endwar


cwar = class("cwar",cdatabaseable)

function cwar:init()
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
end

function cwar:startwar()
	self:loopround()
end

function cwar:endwar()
end

function cwar:loopround()

end

function cwar:beginround()
end

function cwar:endround()
end

function cwar:gettargets(targettype)
	if targetid == self.pid then
		return self
	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
		return self.id_card[targetid]
	else
		local war = warmgr.getobject(self.warid)
		local opponent
		if self.type == "attacker" then
			opponent = war.defenser
		else
			oppoent = war.attacker
		end
		if opponent.init_warcardid <= targetid and targetid <= opponent.warcardid then
			return opponent.id_card[targetid]
		else
			assert(opponent.pid == targetid,"Invalid targetid:" .. tostring(targetid))
			return opponent
		end
	end
end

return cwar
