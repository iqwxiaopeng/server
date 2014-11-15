--<<card 导表开始>>
require "script.card"
ccard15110 = class("ccard15110",ccard,{
    sid = 15110,
    race = 5,
    name = "name10",
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

function ccard15110:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15110:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15110:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
