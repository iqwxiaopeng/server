--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12504"

ccard22504 = class("ccard22504",ccustomcard,{
    sid = 22504,
    race = 2,
    name = "愤怒之锤",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 3,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 33,
    desc = "造成3点伤害,抽一张牌。",
})

function ccard22504:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22504:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22504:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22504
