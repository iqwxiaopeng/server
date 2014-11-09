require "script.base"
require "script.war.warcard"

cwarobj = class("cwarobj",cdatabaseable)

function cwarobj:init(pid,warid,typ)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "cwarobj"
	})
	self.data = {}
	self.hand_cards = {}
	self.left_cards = {}
	self.war_cards = {}
	self.hand_card_limit = 10
	self.id_card = {}
	self.type = typ
	self.warid = warid
	if typ == "attacker" then
		self.init_warcardid = 100
		self.warcardid = 100
	else
		self.init_warcardid = 200
		self.warcardid = 200
	end
end

function cwarobj:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
end

function cwarobj:save()
	local data = {}
	data.data = self.data
	return data
end

function cwarobj:clear()
end

function cwarobj:gen_warcardid()
	self.warcardid = self.warcardid + 1
	return self.warcardid
end

function cwarobj:pick_card(israndom)
	local pos = #self.left_cards
	if israndom then
		pos = math.random(#self.left_cards)
	end
	local sid = table.remove(self.left_cards,pos)
	return sid
end

function cwarobj:putinhand(sid)
	if #self.hand_cards >= self.hand_card_limit then
		self:destroy_card(sid)
		return
	end
	local id = self:gen_warcardid()
	if id > self.init_warcardid then
		logger.log("error","war",string.format("#%d putinhand,type=%s sid=%d id(%d) overlimit",self.pid,self.type,sid,id))
		self:destroy_card(sid)
		return
	end
	local warcard = cwarcard.new(id,sid)
	table.insert(self.hand_cards,warcard)
	warcard.pos = #self.hand_cards
	assert(self.id_card[id] == nil,"repeat warcardid:" .. tostring(id))
	self.id_card[id] = warcard
	self:refresh_card(warcard)
	self:after_putinhand(warcard)
end

local cardnum_warcards = {

}
function cwarobj:after_putinhand(warcard)
	for i,warcard in ipairs(self.hand_cards) do
		if cardnum_warcards[warcard.sid] then
			warcard.cost_crystal = warcard.cost_crystal - 1
		end
	end
end

function after_play_card(warcard)
	for i,warcard in ipairs(self.hand_cards) do
		if cardnum_warcards[warcard.sid] then
			warcard.cost_crystal = warcard.cost_crystal + 1
		end
	end
end

function cwarobj:destroy_card(sid)
end

function self:refresh_card(warcard)
end

function cwarobj:get_seltarget(targetid)
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



function cwarobj:get_seltarget_type(targetid)
	if targetid == self.pid then
		return SEL_TARGET_TYPE_SELF
	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
		return SEL_TARGET_TYPE_FRIENDLY_FOOTMAN
	else
		local war = warmgr.getwar(self.warid)
		local opponent
		if self.type == "attacker" then
			opponent = war.defenser
		else
			oppoent = war.attacker
		end
		if opponent.init_warcardid <= targetid and targetid <= opponent.warcardid then
			return SEL_TARGET_TYPE_ENEMY_FOOTMAN
		else
			assert(opponent.pid == targetid,"Invalid targetid:" .. tostring(targetid))
			return SEL_TARGET_TYPE_ENEMY
		end
	end
end

function cwarobj:gettargets(targettype)
end

function cwarobj:parse_effects(seltarget,effects)
	for targettype,actions in pairs(effects) do
		local targets
		if targettype == "seltarget" then
			targets = {seltarget,}
		elseif targettype == "left_target" then
			targets = {self:getlefttarget(seltarget),}
		elseif targettype == "right_target" then
			targets = {self:getrighttarget(seltarget),}
		else
			targets = self:gettargets(targettype)
		end
		assert(targets,"Not found targettype:" .. tostring(targettype))
		for _,target in ipairs(targets) do
			for condtion,action in pairs(actions) do
				local effect
				if type(condition) == "string" then
					if target:hascondition(condition) then
						self:parse_effects(target,action)
					end
				else
					target:addeffect(action)
				end
			end
		end

	end
end

function cwarobj:play_card(warcard,seltargetid)
	local seltarget
	if seltargetid then
		local sel_target_type = self:get_seltarget_type(seltargetid)
		local targettypes = assert(warcard.targettype)
		if not findintable(targettypes,sel_target_type) then
			logger.log("critical","war",string.format("[playe_card] error target type,targetid=%d targettype=%d need_targettypes=%s",seltargetid,sel_target_type,targettypes))
			return
		end
		seltarget = assert(self:get_seltarget(seltargetid),"Not found target:" .. tostring(seltargetid))
	end
	if warcard.type == "footman" then
		self:add_footman(warcard)
	end
	local warcryeffect = warcard:getwarcryeffect()
	parse_effects(seltarget,warcryeffect)
end

function cwarobj:usecard_to_attack(warcard,targetid)
	local sid = warcard.sid
end

function cwarobj:recycle_card(warcard)
end

return cwarobj
