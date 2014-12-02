--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16114 = class("ccard16114",ccustomcard,{
    sid = 16114,
    race = 6,
    name = "火车王里诺艾",
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 2,
    crystalcost = 5,
    targettype = 0,
    desc = "冲锋,战吼：为你的对手召唤2只1/1的雏龙。",
})

function ccard16114:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16114:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16114:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16114
