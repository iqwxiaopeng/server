--<<card 导表开始>>
require "script.card"
ccard24115 = class("ccard24115",ccard,{
    sid = 24115,
    race = 4,
    name = "name15",
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

function ccard24115:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24115:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard24115:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
