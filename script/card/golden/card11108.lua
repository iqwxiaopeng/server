--<<card 导表开始>>
require "script.card"
ccard11108 = class("ccard11108",ccard,{
    sid = 11108,
    race = 1,
    name = "name8",
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

function ccard11108:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11108:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11108:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
