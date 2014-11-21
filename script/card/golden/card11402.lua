--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11402 = class("ccard11402",ccustomcard,{
    sid = 11402,
    race = 1,
    name = "寒冰护体",
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
    targettype = 11,
    desc = "奥秘：当你的英雄受到攻击时,获得8点护甲值",
})

function ccard11402:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11402:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11402:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11402:use(target)
	local war = warmgr.getwar(self.id)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

local heroevent = {}
ccard11402.hero = heroevent

function heroevent:__ondefense(attacker)
	local war = warmgr.getwar(self.id)
	local warobj = war:getwarobj(self.pid)
	warobj:delsecret(self.id)
	unregister(warobj.hero,"ondefense",self.id)
	warobj.hero:adddef(8)
end

return ccard11402
