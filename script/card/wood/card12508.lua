--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12508 = class("ccard12508",ccustomcard,{
    sid = 12508,
    race = 2,
    name = "列王守卫",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 6,
    crystalcost = 7,
    targettype = 0,
    desc = "战吼：为你的英雄恢复6点生命值。",
})

function ccard12508:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12508:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12508:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard12508
