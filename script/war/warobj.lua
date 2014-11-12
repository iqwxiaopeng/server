require "script.base"
require "script.war.warcard"
require "script.war.categorytarget"

cwarobj = class("cwarobj",cdatabaseable)

function cwarobj:init(conf,warid)
	cdatabaseable.init(self,{
		pid = conf.pid,
		flag = "cwarobj"
	})
	self.data = {}
	self.state = "init"
	self.srvname = conf.srvname
	self.race = conf.cardtable.race
	-- xxx
	self.crystal = 0
	self.empty_crystal = 0
	self.handcards = {}
	self.leftcards = {}
	for cardsid,num in pairs(conf.cardtable.cards) do
		for i = 1,num do
			table.insert(self.leftcards,cardsid)
		end
	end
	self.warcards = {}
	self.hand_card_limit = 10
	self.id_card = {}
	self.warid = warid
	if  conf.isattacker then
		self.type = "attacker"
		self.init_warcardid = 100
		self.warcardid = 100
	else
		self.type = "defenser"
		self.init_warcardid = 200
		self.warcardid = 200
	end
	self.footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.animal_footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.fish_footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.animal_footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.fish_footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.secret_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
	self.warcy_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
	})
end

function cwarobj:onhurt(warcard)
	if self:isfootman(warcard.type) then
		if self:is_animal_footman(warcard.type) then
		elseif self:is_fish_footman(warcard.type) then
			for i,v in ipairs(self.all_fish_footman.onhurt) do
				
			end
		end
	end
end

local valid_event = {
	onhurt = true,
	ondie = true,
	ondefense = true,
	onattack = true,
}
function cwarobj:isevent(event)
	if type(event) == "number" then
		return false
	end
	return valid_event[event]
end

local valid_condition = {
	freeze = true,
	unfreeze = true,
	hurt = true,
	unhurt = true,
	sneer = true,
	unsneer = true,
	dblatk = true,
	undblatk = true,
	sneak = true,
	unsneak = true,
}

function cwarobj:iscondition(condition)
	if type(condition) == "number" then
		return false
	end
	return valid_condition[condition]
end

function cwarobj:onaddfootman(warcard)
	local warcardid = warcardid
	local aliveeffect = warcard.aliveeffect
	for scope,actions in pairs(aliveeffect) do
		local obj
		if scope == "self" then
			obj = self
		else
			assert(scope == "enemy")
			obj = self.enemy
		end
		for targettype,effects in pairs(actions) do
			local target = assert(obj[targettype],"Invalid targettype:" .. tostring(targettype))
			for event,effect in pairs(effects) do
				if not self:isevent(event) then
					for k,v in pairs(effect) do
						local func = target[k]
						func(target,v,warcardid)
					end
				else
					local events = assert(target[event],"Invalid condition:" .. tostring(condtion))
					for k,v in pairs(effect) do
						if not self:istargettype(k) then
							table.insert(events,{src=warcardid,target="trigger",value=v,})
						else
							if k == "cardself" then
								for k1,v1 in pairs(v) do
									if not self:isstate(k1) then
										table.insert(events,{src=warcardid,target=warcardid,value=v1,})
									else
										table.insert(events,{src=warcardid,target=warcardid,state=k1,value=v1,})
									end
								end
							elseif k == "enemy" then
								local obj = obj.enemy
								for k1,v1 in pairs(v) do
									local target = assert(obj[k1],"Invalid targettype:" .. tostring(k1))
									local targettype = "enemy." .. k1
									for k2,v2 in pairs(v1) do
										if not self:iscondition(k2) then
											table.insert(events,{src=warcardid,target=targettype,value=v2,})
										else
											table.insert(evnets,{src=warcardid,target=targettype,condition=v2,value=v2,})
										end
									end
								end
							else
								local target = assert(obj[k],"Invalid targetype:" .. tostring(k))
								local targettype = k
								for k1,v1 in pairs(v) do
									if not self:isstate(k1) then
										table.insert(events,{src=warcardid,target=targettype,value=v1,})
									else
										table.insert(events,{src=warcardid,target=targettype,state=k1,value=v1,})
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local function gettargets(targettypes,referto_id)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(referto_id)
	local targets = {}
	for targettype in string.gmatch("([^;]+)") do
		local obj = owner
		for k in string.match("([^.]+)") do
			if k ~= "self" then
				obj = obj[k]	
			end
		end
		assert(obj,"Invalid targettype:" .. tostring(targettype))
		table.insert(targets,obj)
	end
	return targets
end

local valid_event = {
	onhurt = true,
	ondie = true,
	onattack = true,
	ondefense = true,
	onadd = true,
	ondel = true,
}

local function isevent(event)
	return valid_event[event]
end

local valid_condition = {
	freeze = true,
	unfreeze = true,
	hurt = true,
	unhurt = true,
	sneer = true,
	unsneer = true,
	dblatk = true,
	undblatk = true,
	sneak = true,
	unsneak = true,
}
local function iscondition(condition)
	return valid_condtion[condtion]
end


function cwarobj:parseeffect(warcard,seltarget)
	local pos = seltarget.pos
	local warcardid = warcard.id
	local effects = warcard.aliveeffect
	for targettype,effect in pairs(effects) do
		if type(targettype) == "number" then
			for cmd,value in pairs(effect) do
				local func = self[cmd]
				func(self,value,warcardid)
			end
		else
			local targets
			if targettype == "seltarget" then
				targets = {seltarget,}
			elseif targettype == "lefttarget" then
				targets = {self.warcards[pos-1],}
			elseif targettype == "righttarget" then
				targets = {self.warcards[pos+1],}
			else
				targets = self:gettargets(targettype,warcardid)
			end
			for condition,action in pairs(effect) do
				if type(condtion) == "number" then
					for _,target in ipairs(targets) do
						for cmd,value in pairs(action) do
							local func = target[cmd]
							func(target,value,warcardid)
						end
					end
				else
					if isevent(condition) then
						local event = condtion
						for _,target in ipairs(targets) do
							local events = assert(target[event],"Invalid event:" .. tostring(event))
							table.insert(events,{srcid=warcardid,action=action})
						end
					else
						assert(iscondtion(condtion),"Invalid condtion:" .. tostring(condtion))
						for _,target in ipairs(targets) do
							if target:hascondtion(condtion) then
								for cmd,value in pairs(action) do
									local func = target[cmd]
									func(target,value,warcardid)
								end
							end
						end
					end
				end
			end
		end
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

function cwarobj:pickcard(israndom)
	local pos = #self.leftcards
	if israndom then
		pos = math.random(#self.leftcards)
	end
	local sid = table.remove(self.leftcards,pos)
	return sid
end

-- 置入牌库
function cwarobj:puttocardlib(cardsid,israndom)
	local pos = #self.leftcards
	if israndom then
		pos = math.random(#self.leftcards)
	end
	table.insert(self.leftcards,pos,cardsid)
end

function cwarobj:shuffle_cards()
	shuffle(self.leftcards,true)	
end

function cwarobj:random_handcard(cnt)
	assert(cnt == 3 or cnt == 4,"Invalid random_handcards cnt:" .. tostring(cnt))
	local handcards = {}
	for i = 1,cnt do
		table.insert(handcards,self:pickcard())
	end
	-- 先手
	if cnt == 3 then
		table.insert(handcards,1)
	end
	self.state = "random_handcards"
	return handcards
end

function cwarobj:confirm_handcard(handcards)
	for _,cardsid in ipairs(handcards) do
		local pos = findintable(self.tmp_handcards,cardsid)
		if not pos then
			logger.log("warning","war",string.format("#%d confirm_handcard,non match cardsid:%d",self.pid,cardsid))
			cluster.call("warsrvmgr","war","endwar",self.pid,self.warid)
			cluster.call("warsrvmgr","war","endwar",self.enemy.pid,self.warid)
			return
		else
			table.remove(self.tmp_handcards,pos)
		end
	end
	self.handcards = handcards
	for _,cardsid in ipairs(self.tmp_handcards) do
		self:putocardlib(cardsid,true)
	end
	self.state = "confirm_handcards"
	logger.log("info","war",format("#%d comfirm_handcards,handcards:%s leftcards:%s",self.pid,self.handcards,self.leftcards))
end



function cwarobj:endround(roundcnt)
	assert(roundcnt == self.roundcnt)
	if self.state ~= "beginround" then
		logger.log("warning","war",string.format("#%d endround,but round not start,srvname=%s rondcnt=%d",self.pid,self.srvname,roundcnt))
		return
	end
	self.state = "endround"
	self.enemy:beginround()
end

function cwarobj:beginround()
	self.roundcnt = self.roundcnt + 1
	local cardsid = self:pickcard()
	logger.log("info","war",string.format("#%d beginround,srvname=%s roundcnt=%d cardsid=%d",self.pid,self.srvname,self.roundcnt,cardsid))
	self:putinhand(cardsid)
	self.state = "beginround"
	if self.empty_crystal < 10 then
		self.empty_crystal = self.empty_crystal + 1
	end
	self.crystal = self.empty_crystal
	cluster.call(self.srvname,"forward",self.pid,"war","beginround",{
		roundcnt = self.roundcnt,
	})
end

function cwarobj:playcard(warcardid)
	local warcard = self.id_card[warcardid]
	if not warcard then
		logger.log("warning","war",string.format("#%d playcard(non exists warcardid),srvname=%s warcardid=%d",self.pid,srvname,warcardid))
		return
	end
	if warcard.crystalcost > self.crystal then
		return
	end
	self:addcrystal(-warcard.crystalcost)	
end

function cwarobj:putinhand(cardsid)
	if #self.hand_cards >= self.hand_card_limit then
		self:destroy_card(cardsid)
		return
	end
	local warcardid = self:gen_warcardid()
	if warcardid > self.init_warcardid then
		logger.log("error","war",string.format("#%d putinhand,type=%s cardsid=%d warcardid=%d overlimit",self.pid,self.type,cardsid,warcardid))
		self:destroy_card(cardsid)
		return
	end
	local warcard = cwarcard.new(warcardid,cardsid)
	table.insert(self.hand_cards,warcard)
	warcard.pos = #self.hand_cards
	assert(self.id_card[warcardid] == nil,"repeat warcardid:" .. tostring(warcardid))
	self.id_card[warcardid] = warcard
	self:refresh_card(warcard)
	self:after_putinhand(warcard)
end

local cardnum_warcards = {

}
function cwarobj:after_putinhand(warcard)
end

function after_playcard(warcard)
end

function cwarobj:destroy_card(sid)
end

function cwarobj:refresh_card(warcard)
end

--function cwarobj:get_seltarget(targetid)
--	if targetid == self.pid then
--		return self
--	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
--		return self.id_card[targetid]
--	else
--		local war = warmgr.getobject(self.warid)
--		local opponent
--		if self.type == "attacker" then
--			opponent = war.defenser
--		else
--			oppoent = war.attacker
--		end
--		if opponent.init_warcardid <= targetid and targetid <= opponent.warcardid then
--			return opponent.id_card[targetid]
--		else
--			assert(opponent.pid == targetid,"Invalid targetid:" .. tostring(targetid))
--			return opponent
--		end
--	end
--end
--
--
--
--function cwarobj:get_seltarget_type(targetid)
--	if targetid == self.pid then
--		return SEL_TARGET_TYPE_SELF
--	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
--		return SEL_TARGET_TYPE_FRIENDLY_FOOTMAN
--	else
--		local war = warmgr.getwar(self.warid)
--		local opponent
--		if self.type == "attacker" then
--			opponent = war.defenser
--		else
--			oppoent = war.attacker
--		end
--		if opponent.init_warcardid <= targetid and targetid <= opponent.warcardid then
--			return SEL_TARGET_TYPE_ENEMY_FOOTMAN
--		else
--			assert(opponent.pid == targetid,"Invalid targetid:" .. tostring(targetid))
--			return SEL_TARGET_TYPE_ENEMY
--		end
--	end
--end
--
--function cwarobj:gettargets(targettype)
--end
--
--function cwarobj:parse_effects(seltarget,effects)
--	for targettype,actions in pairs(effects) do
--		local targets
--		if targettype == "seltarget" then
--			targets = {seltarget,}
--		elseif targettype == "left_target" then
--			targets = {self:getlefttarget(seltarget),}
--		elseif targettype == "right_target" then
--			targets = {self:getrighttarget(seltarget),}
--		else
--			targets = self:gettargets(targettype)
--		end
--		assert(targets,"Not found targettype:" .. tostring(targettype))
--		for _,target in ipairs(targets) do
--			for condtion,action in pairs(actions) do
--				local effect
--				if type(condition) == "string" then
--					if target:hascondition(condition) then
--						self:parse_effects(target,action)
--					end
--				else
--					target:addeffect(action)
--				end
--			end
--		end
--
--	end
--end
--
--function cwarobj:play_card(warcard,seltargetid)
--	local seltarget
--	if seltargetid then
--		local sel_target_type = self:get_seltarget_type(seltargetid)
--		local targettypes = assert(warcard.targettype)
--		if not findintable(targettypes,sel_target_type) then
--			logger.log("critical","war",string.format("[playe_card] error target type,targetid=%d targettype=%d need_targettypes=%s",seltargetid,sel_target_type,targettypes))
--			return
--		end
--		seltarget = assert(self:get_seltarget(seltargetid),"Not found target:" .. tostring(seltargetid))
--	end
--	if warcard.type == "footman" then
--		self:add_footman(warcard)
--	end
--	local warcryeffect = warcard:getwarcryeffect()
--	parse_effects(seltarget,warcryeffect)
--end
--
--function cwarobj:usecard_to_attack(warcard,targetid)
--	local sid = warcard.sid
--end
--
--function cwarobj:recycle_card(warcard)
--end


function cwarobj:onfail()
end

function cwarobj:onwin()
end

return cwarobj
