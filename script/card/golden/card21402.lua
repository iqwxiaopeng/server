--<<card 导表开始>>
local ccustomcard = require "script.card.golden.card11402"

ccard21402 = class("ccard21402",ccustomcard,{
    sid = 21402,
    race = 1,
    name = "寒冰护体",
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
    crystalcost = 3,
    targettype = 11,
    desc = "奥秘：当你的英雄受到攻击时,获得8点护甲值",
})

function ccard21402:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21402:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21402:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21402
