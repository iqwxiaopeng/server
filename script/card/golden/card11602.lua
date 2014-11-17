--<<card 导表开始>>
require "script.card"
ccard11602 = class("ccard11602",ccard,{
    sid = 11602,
    race = 1,
    name = "小羊",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 0,
    shield = 0,
    type = 1202,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 23,
    desc = "None",
})

function ccard11602:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11602:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11602:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard11602