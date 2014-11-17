--<<card 导表开始>>
require "script.card"
ccard21302 = class("ccard21302",ccard,{
    sid = 21302,
    race = 1,
    name = "暴风雪",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 2,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 6,
    targettype = 22,
    desc = "对所有敌方随从造成2点伤害,并使其冻结",
})

function ccard21302:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21302:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21302:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21302
