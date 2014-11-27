require "script.base"
require "script.war.warobj"
require "script.logger"

--- 1. player ready
--- 2. startwar
--- 3. loopround
--- 4. endwar

__warid = __warid or 0

cwar = class("cwar",cdatabaseable)

function cwar:init(profile1,profile2)
	__warid = __warid + 1
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
	self.warid = __warid
	self.attacker = cwarobj.new(profile1,self.warid)
	self.defenser = cwarobj.new(profile2,self.warid)
	self.attacker.enemy = self.defenser
	self.defenser.enemy = self.attacker
	self.warlogs = {}
	self.s2cdata = {
		[self.attacker.pid] = {},
		[self.defenser.pid] = {},
	}
end

function cwar:adds2c(pid,cmd,args)
	local netdata = {pid = pid,cmd=cmd,args=args,}
	local enemypid = self.attacker.pid
	if enemypid == pid then
		enemypid = self.defenser.pid
	end
	if cmd == "putinhand" then
		table.insert(self.s2cdata[pid],netdata)
		netdata = copy(netdata)
		netdata.args = nil
		table.insert(self.s2cdata[enemypid],netdata)
	else
		table.insert(self.s2cdata[pid],netdata)
		table.insert(self.s2cdata[enemypid],netdata)
	end
end

function cwar:s2csync()
	local attacker_s2cdata = self.s2cdata[self.attacker.pid]
	local defenser_s2cdata = self.s2cdata[self.defenser.pid]
	self.s2cdata = {
		[self.attacker.pid] = {},
		[self.defenser.pid] = {},
	}
	logger.log("debug","war",format("[warid=%d] s2csync,attacker=%d defenser=%d attacker_s2cdata=%s defenser_s2cdata=%s",self.warid,self.attacker.pid,self.defenser.pid,attacker_s2cdata,defenser_s2cdata))
	if next(attacker_s2cdata) then
		cluster.call(self.attacker.srvname,"forward",self.attacker.pid,"war","sync",{
			cmds = attacker_s2cdata
		})
	end
	if next(defenser_s2cdata) then
		cluster.call(self.defenser.srvname,"forward",self.defenser.pid,"war","sync",{
			cmds = defenser_s2cdata
		})
	end
end

function cwar:getwarobj(pid)
	if self.attacker.pid == pid then
		return self.attacker
	else
		return self.defenser
	end
end

function cwar:getowner(id)
	if self.attacker.init_warcardid <= id and id <= self.attacker.warcardid then
		return self.attacker 
	elseif self.defenser.init_warcardid <= id and id <= self.defenser.warcardid then
		return self.defenser
	else
		error("Invalid id:" .. tostring(id))
	end

end

function cwar:startwar()
	logger.log("info","war",string.format("startwar %d(srvname=%s) -> %d(srvname=%s)",self.attacker.pid,self.attacker.srvname,self.defenser.pid,self.defenser.srvname))
	-- 洗牌
	self.attacker:shuffle_cards()
	self.defenser:shuffle_cards()
	-- 发首牌
	self.attacker.tmp_handcards = self.attacker:random_handcard(3)
	self.defenser.tmp_handcards = self.defenser:random_handcard(4)
	cluster.call(self.attacker.srvname,"forward",self.attacker.pid,"war","random_handcard",{
		cardsids = self.attacker.tmp_handcards,
	})
	cluster.call(self.defenser.srvname,"forward",self.defenser.pid,"war","random_handcard",{
		cardsids = self.defenser.tmp_handcards,
	})
end

function cwar:endwar(winner)
	-- 洗牌
	local loser = self.attacker
	if self.attacker.pid == winner.pid then
		loser = self.defenser
	end
	logger.log("info","war",string.format("endtwar,winner=%d(srvname=%s) loser=%d(srvname=%s)",winner.pid,winner.srvname,loser.pid,loser.srvname))
	winner:onwin()
	loser:onfail()
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

function cwar:addwarlog(warlog)
	table.insert(self.warlogs,warlog)
end

return cwar
