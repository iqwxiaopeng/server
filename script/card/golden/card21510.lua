--<<card 导表开始>>
local ccustomcard = require "script.card.golden.card11510"

ccard21510 = class("ccard21510",ccustomcard,{
    sid = 21510,
    race = 1,
    name = "烈焰风暴",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 1101,
    magic_hurt = 4,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 7,
    targettype = 0,
    desc = "对所有敌方随从造成4点伤害",
})

function ccard21510:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21510:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21510:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21510
