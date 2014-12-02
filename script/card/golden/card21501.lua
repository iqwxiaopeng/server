--<<card 导表开始>>
local ccustomcard = require "script.card.golden.card11501"

ccard21501 = class("ccard21501",ccustomcard,{
    sid = 21501,
    race = 1,
    name = "变形术",
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
    type = 101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 22,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard21501:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21501:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21501:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21501
