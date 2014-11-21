--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard14201 = class("ccard14201",ccustomcard,{
    sid = 14201,
    race = 4,
    name = "name16",
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    multiatk = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 22,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard14201:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14201:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard14201:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard14201