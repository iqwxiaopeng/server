--<<card 导表开始>>
require "script.card"
ccard11505 = class("ccard11505",ccard,{
    sid = 11505,
    race = 1,
    name = "魔爆术",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "对所有敌方随从造成1点伤害",
})

function ccard11505:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11505:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11505:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard11505
