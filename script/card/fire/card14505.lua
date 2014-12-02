--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard14505 = class("ccard14505",ccustomcard,{
    sid = 14505,
    race = 4,
    name = "奥术射击",
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
    magic_hurt = 2,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 33,
    desc = "造成2点伤害。",
})

function ccard14505:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14505:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard14505:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard14505
