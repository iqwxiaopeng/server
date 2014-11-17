--<<card 导表开始>>
require "script.card"
ccard21509 = class("ccard21509",ccard,{
    sid = 21509,
    race = 1,
    name = "冰霜新星",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "冻结所有敌方随从",
})

function ccard21509:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21509:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21509:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21509