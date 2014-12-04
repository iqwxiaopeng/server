--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12404 = class("ccard12404",ccustomcard,{
    sid = 12404,
    race = 2,
    name = "以眼还眼",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "奥秘：每当你的英雄受到伤害时,对敌方英雄造成等量的伤害。",
})

function ccard12404:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12404:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12404:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12404:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"onhurt",self.id)
end

function ccard12404:__onhurt(hurtvalue,srcid)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:delsecret(self.id)
	unregister(warobj.hero,"onhurt",self.id)
	warobj.enemy:addhp(-hurtvalue,self.id)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard12404
