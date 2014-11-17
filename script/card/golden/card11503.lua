--<<card 导表开始>>
require "script.card"
ccard11503 = class("ccard11503",ccard,{
    sid = 11503,
    race = 1,
    name = "奥术飞弹",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 3,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "造成3点伤害,随机分配给敌方角色",
})

function ccard11503:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11503:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11503:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard11503
