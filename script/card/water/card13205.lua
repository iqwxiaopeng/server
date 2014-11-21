--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13205 = class("ccard13205",ccustomcard,{
    sid = 13205,
    race = 3,
    name = "name21",
    magic_immune = 0,
    assault = 0,
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
    targettype = 0,
    desc = "对所有敌方随从造成1点伤害",
})

function ccard13205:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13205:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13205:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard13205