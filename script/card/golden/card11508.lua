--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11508 = class("ccard11508",ccustomcard,{
    sid = 11508,
    race = 1,
    name = "寒冰箭",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 3,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 33,
    desc = "对一个角色造成3点伤害,并使其冻结",
})

function ccard11508:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11508:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11508:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11508:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = ccard11508.magic_hurt + warobj:get_magic_hurt_adden()
	target:addhp(-hurtvalue,self.id)
	target:setstate("freeze",1)
end

return ccard11508
