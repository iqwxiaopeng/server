--<<card 导表开始>>
local ccustomcard = require "script.card.water.card13506"

ccard23506 = class("ccard23506",ccustomcard,{
    sid = 23506,
    race = 3,
    name = "心灵震爆",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 5,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 21,
    desc = "对敌方英雄造成5点伤害。",
})

function ccard23506:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23506:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard23506:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard23506
