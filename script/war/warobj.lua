require "script.base"
require "script.war.warcard"

cwarobj = class("cwarobj",cdatabaseable)

function cwarobj:init(pid,typ,warid)
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

function cwarobj:gettarget(targetid)
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

function cwarobj:play_card(warcard,targetid)
	local target
	if targetid then
		target = self:gettarget(targetid)
	end
	local sid = warcard.sid
	local cardcls = getclassbycardsid(sid)	
	local warcry = cardcls.warcry
	if warcry and warcry.type ~= 0 then
		if warcry.type == WARCRY_TYPE_HP then
			target:addhp(warcry.value)
		elseif warcry.type == WARCRY_TYPE_EMPTY_CRYSTAL then
			target:addemptycrystal(warcry.value)
		elseif warcry.type == WARCRY_TYPE_CRYSTAL then
			target:addcrystal(warcry.value)
		elseif warcry.type == WARCRY_TYPE_PICKCARD then
			for i,warcry.value do
				local sid = self:
			end
		end
		local effect = self:create_effect(cardcls.warcry)
		warcard:push_effect(effect)
	end
end

function cwarobj:usecard_to_attack(warcard,targetid)
	local sid = warcard.sid
end

function cwarobj:recycle_card(warcard)
end

return cwarobj
