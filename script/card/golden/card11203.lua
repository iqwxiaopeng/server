--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11203 = class("ccard11203",ccustomcard,{
    sid = 11203,
    race = 1,
    name = "扰咒术",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    type = 1101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "奥秘：当一个敌方法术以一个随从作为目标时,召唤一个1/3的随从并使其成为新目标",
})

function ccard11203:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11203:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11203:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11203:__onplaycard(warcard,pos,target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if is_magiccard(warcard.type) and is_footman(target.type) then
		warobj:delsecret(self.id)
		unregister(warobj.enemy,"onplaycard",self.id)
		local cardsid = isprettycard(self.sid) and 21603 or 11603
		local newtarget = warobj:newwarcard(cardsid)
		warobj:addfootman(newtarget)
		warcard:use(newtarget)
		return true	
	end
	return false
end

function ccard11203:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.enemy,"onplaycard",self.id)
end

return ccard11203
