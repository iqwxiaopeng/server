--<<card 导表开始>>
local ccustomcard = require "script.card.golden.card11603"

ccard21603 = class("ccard21603",ccustomcard,{
    sid = 21603,
    race = 1,
    name = "扰咒师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 1201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 0,
    decomposechip = 0,
    atk = 1,
    hp = 3,
    crystalcost = 0,
    targettype = 23,
    desc = "None",
})

function ccard21603:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21603:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21603:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21603
