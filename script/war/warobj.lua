require "script.base"
require "script.war.warcard"
require "script.war.categorytarget"
require "script.war.aux"
require "script.war.hero"

local WAR_CARD_LIMIT = 10
local HAND_CARD_LIMIT = 10
local MAX_CARD_NUM = 200

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
	self.secretcards = {}
	self.warcards = {}
	self.hand_card_limit = 10
	self.id_card = {}
	self.warid = warid
	self.tiredvalue = 0
	self.roundcnt = 0
	if  conf.isattacker then
		self.type = "attacker"
		self.init_warcardid = 100
		self.warcardid = 100
	else
		self.type = "defenser"
		self.init_warcardid = 300
		self.warcardid = 300
	end
	self.hero = chero.new({
		pid = self.pid,
		warid = self.warid,
		maxhp = 30,
		skillcost = 2,
	})
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
	self.onplaycard = {}
	self.onbeginround = {}
	self.onendround = {}
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
	if pos == 0 then
		return 0
	end
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
	for _,cardsid in ipairs(handcards) do
		self:putinhand(cardsid)
	end
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
	for id,warcard in pairs(self.id_card) do
		if warcard.inarea ~= "graveyard" then
			if warcard:getstate("freeze") then
				local lifecircle = warcard:getstate("freeze") - 1
				if lifecircle <= 0 then
					warcard:delstate("freeze")
				end
			end
			for i = #warcard.buffs,1,-1 do
				local buff = warcard.buffs[i]
				if buff.value.lifecircle then
					buff.value.lifecircle = buff.value.lifecircle
					if buff.value.lifecircle <= 0 then
						warcard:delbuff(buff.srcid,i)
					end
				end
			end
		end
	end
	self:__onendround(self.roundcnt)
	cluster.call(self.srvname,"forward",self.pid,"war","endround",{
		roundcnt = self.roundcnt,
	})
	self.enemy:beginround()
end

function cwarobj:beginround()
	self.roundcnt = self.roundcnt + 1
	logger.log("info","war",string.format("#%d beginround,srvname=%s roundcnt=%d",self.pid,self.srvname,self.roundcnt))
	self.state = "beginround"
	self.hero:delstate("immune")
	self:__onbeginround(self.roundcnt)
	local cardsid = self:pickcard()
	self:putinhand(cardsid)
	if self.empty_crystal < 10 then
		self.empty_crystal = self.empty_crystal + 1
	end
	self.crystal = self.empty_crystal
	cluster.call(self.srvname,"forward",self.pid,"war","beginround",{
		roundcnt = self.roundcnt,
	})
end

function cwarobj:gettarget(targetid)
	if self.init_warcardid <= targetid and targetid <= self.warcardid then
		if targetid == self.hero.id then
			return self.hero
		else
			return self.id_card[targetid]
		end
	elseif self.enemy.init_warcardid <= targetid and targetid <= self.enemy.warcardid then
		if targetid == self.enemy.hero.id then
			return self.enemy.hero
		else
			return self.enemy.id_card[targetid]
		end
	else
		assert("Invalid targetid:" .. tostring(targetid))
	end
end

function cwarobj:getcategorys(type)
	local ret = {}
	if is_animal_footman(type) then
		table.insert(ret,self.animal_footman)
	elseif is_fish_footman(type) then
		table.insert(ret,self.fish_footman)
	end
	if is_footman(type) then
		table.insert(ret,self.footman)
	end
	return ret
end

local builtin_states = {
	sneer = true,
	assault = true,
	multiatk = true,
	shield = true,
}

function cwarobj:onaddfootman(warcard)
	local cardcls = getclassbycardsid(warcard.sid)
	for state,_ in pairs(builtin_states) do
		if cardcls[state] ~= 0 then
			warcard:setstate(state,cardcls[state])
		end
	end
	local categorys = self:getcategorys(self.type)
	for _,category in ipairs(categorys) do
		category:addobj(warcard)
	end
	cardcls.register(warcard)
end

function cwarobj:addfootman(warcard,pos)
	assert(1 <= pos and pos <= #self.warcards+1,"Invalid pos:" .. tostring(pos))
	local num = #self.warcards
	if num >= WAR_CARD_LIMIT then
		return
	end
	table.insert(self.warcards,warcard.id)
	warcard.inarea = "war"
	warcard.pos = pos
	for i = pos+1,num do
		local id = self.warcards[i]
		local card = self.id_card[id]
		card.pos = i
	end
	self:onaddfootman(warcard)
end

function cwarobj:ondelfootman(warcard)
	local cardcls = getclassbysid(warcard.sid)
	local categorys = self:getcategorys(self.type)
	for _,category in ipairs(categorys) do
		category:delobj(warcard.id)
	end
	cardcls.unregister(warcard)
end

function cwarobj:delfootman(warcard)
	local pos = assert(warcard.pos)
	self:ondelfootman(warcard)
	for i = pos + 1,#self.warcards do
		local id = self.warcards[i]
		local card = self.id_card[id]
		card.pos = i - 1
	end
	table.remove(self.warcards,pos)
	warcard.inarea = "graveyard"
end

function cwarobj:playcard(warcardid,pos,targetid)
	local warcard = self.id_card[warcardid]
	if not warcard then
		logger.log("warning","war",string.format("#%d playcard(non exists warcardid),srvname=%s warcardid=%d",self.pid,self.srvname,warcardid))
		return
	end
	if warcard.inarea ~= "hand" then
		logger.log("warning","war",string.format("#%d playcard(non handcard),srvname=%s warcardid=%d",self.pid,self.srvname,warcardid))
		return
	end
	local crystalcost = warcard:getcrystalcost()
	if crystalcost > self.crystal then
		return
	end
	self:addcrystal(-crystalcost)
	local cardcls = getclassbycardsid(warcard.sid)
	local target
	if targetid then
		target = self:gettarget(targetid)
	end
	if not self:__onplaycard(warcard,target) then
		if is_footman(warcard.type) then
			self:addfootman(warcard,pos)
		else
			warcard.inarea = "graveyard"
		end
		warcad:use(target)
		--parse_warcry(self,warcardid,cardcls.warcry_effects,target)
	end
	self:removefromhand(warcard)
end

function cwarobj:footman_attack_hero(warcardid)
	local warcard = assert(self.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))	
	if warcard:getstate("freeze") then
		return
	end
	assert(warcard.inarea == "war")
	local atk = warcard:getatk()
	if atk == 0 then
		return
	end
	if warcard:__onattack(self.enemy.hero) then
		return
	end
	if self.enemy.hero:__ondefense(warcard) then
		return
	end
	target:addhp(-atk,warcardid)
end

function cwarobj:footman_attack_footman(warcardid,targetid)
	local warcard = assert(self.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))
	if warcard:getstate("freeze") then
		return
	end
	assert(warcard.inarea == "war")
	local target = self.enemy.id_card[targetid]
	if warcard:__onattack(target) then
		return
	end
	if target:__ondefense(warcard) then
		return
	end
	target:addhp(-warcard:getatk(),warcardid)
	warcard:addhp(-target:getatk(),targetid)
end

function cwarobj:hero_attack_footman(targetid)
	local target = assert(self:gettarget(targetid),"Invalid targetid:" .. tostring(targetid))
	if self.hero:getstate("freeze") then
		return
	end
	local hero_atk = self.hero:getatk()
	if hero_atk == 0 then
		return
	end
	local weapon = self.hero:getweapon()
	if weapon then
		weapon.usecnt = weapon.usecnt - 1
	end
	if self.hero:__onattack(target) then
		return
	end
	if target:__ondefense(self.hero) then
		return
	end
	if weapon then	
		if weapon.usecnt == 0 then
			self.hero:delweapon()
		end
	end
	target:addhp(-hero_atk,self.hero.id)
	self.hero:addhp(-target:getatk(),targetid)
end

function cwarobj:hero_attack_hero()
	if self.hero:getstate("freeze") then
		return
	end
	local hero_atk = self.hero:getatk()
	if hero_atk == 0 then
		return
	end
	local weapon = self.hero:getweapon()
	if weapon then
		weapon.usecnt = weapon.usecnt - 1
	end
	if self.hero:__onattack(self.enemy.hero) then
		return
	end
	if self.enemy.hero:__ondefense(self.hero) then
		return
	end
	if weapon then
		if weapon.usecnt == 0 then
			self.hero:delweapon()
		end
	end
	self.enemy.hero:addhp(-hero_atk,self.hero.id)
end

function cwarobj:hero_useskill(targetid)
	self.hero:useskill(targetid)
end

function cwarobj:newwarcard(cardsid)
	local warcardid = self:gen_warcardid()
	if warcardid >= self.init_warcardid + MAX_CARD_NUM then
		self:destroy_card(cardsid)
		local msg = string.format("#%d putinhand,type=%s cardsid=%d warcardid=%d overlimit",self.pid,self.type,cardsid,warcardid)
		logger.log("error","war",msg)
		error(msg)
	end
	local warcard = cwarcard.new({
		id = warcardid,
		sid = cardsid,
		warid = self.warid,
		pid = self.pid,
	})
	return warcard
end

function cwarobj:putinhand(cardsid)
	if cardsid == 0 then
		self.tiredvalue = self.tiredvalue + 1
		self.hero:addhp(-self.tiredvalue,0)
		return
	end
	if #self.handcards >= HAND_CARD_LIMIT then
		self:destroy_card(cardsid)
		return
	end
	local warcard = self:newwarcard(cardsid)
	table.insert(self.handcards,warcard)
	warcard.pos = #self.handcards
	warcard.inarea = "hand"
	local warcardid = warcard.id
	assert(self.id_card[warcardid] == nil,"repeat warcardid:" .. tostring(warcardid))
	self.id_card[warcardid] = warcard
	self:refresh_card(warcard)
	self:after_putinhand(warcard)
end

function cwarobj:removefromhand(warcard)
	assert(warcard.inarea == "hand")
	local pos = warcard.pos
	assert(warcard == self.handcards[pos])
	local ret = table.remove(self.handcards,pos)
	self:after_removefromhand(warcard)
	return ret
end

function cwarobj:removefromwar(warcard)
	assert(warcard.inarea == "war")
	local pos = warcard.pos
	assert(warcard.id == self.warcards[pos])
	local ret = table.remove(self.warcards,pos)
	self:after_removefromwar(warcard)
	return ret
end

function cwarobj:after_putinhand(warcard)
end

function cwarobj:after_removefromhand(warcard)
end

function cwarobj:after_removefromwar(warcard)
end

function cwarobj:after_playcard(warcard)
end

function cwarobj:destroy_card(sid)
end

function cwarobj:refresh_card(warcard)
end


function cwarobj:hassecret()
	return false
end

function cwarobj:get_addition_magic_hurt()
	return 0
end

function cwarobj:register(type,warcardid)
	return register(self,type,warcardid)
end

function cwarobj:unregister(type,warcardid)
	return unregister(self,type,warcardid)
end

function cwarobj:addsecret(warcardid)
	table.insert(self.secretcards,warcardid)
end

function cwarobj:delsecret(warcardid)
	for _,id in ipairs(self.secretcards) do
		if id == warcardid then
			table.remove(self.secretcards,id)
			break
		end
	end
end

function cwarobj:onfail()
end

function cwarobj:onwin()
end

function cwarobj:__onplaycard(warcard,target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onplaycard) do
		card = warobj.id_card[v]
		cardcls = getclassbysid(card.sid)
		eventresult = cardcls.__onplaycard(card,warcard,target)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__onbeginround(roundcnt)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onbeginround) do
		card = warobj.id_card[v]
		cardcls = getclassbysid(card.sid)
		eventresult = cardcls.__onbeginround(warcard,roundcnt)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__onendround(roundcnt)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,v in ipairs(self.onendround) do
		card = warobj.id_card[v]
		cardcls = getclassbysid(card.sid)
		eventresult = cardcls.__onendround(card,roundcnt)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

return cwarobj
