--<<card 导表开始>>
require "script.card"
ccard15105 = class("ccard15105",ccard,{
    sid = 15105,
    race = 5,
    name = "name5",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 2,
    shield = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
})

function ccard15105:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15105:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15105:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
