--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16124 = class("ccard16124",ccustomcard,{
    sid = 16124,
    race = 6,
    name = "迦顿男爵",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 5,
    crystalcost = 7,
    targettype = 0,
    desc = "在你的回合结束时,对所有其他角色造成2点伤害。",
})

function ccard16124:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16124:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16124:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16124
