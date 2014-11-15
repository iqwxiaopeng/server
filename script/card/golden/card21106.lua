--<<card 导表开始>>
require "script.card"
ccard21106 = class("ccard21106",ccard,{
    sid = 21106,
    race = 1,
    name = "name6",
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

function ccard21106:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21106:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21106:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
