--<<card 导表开始>>
local ccustomcard = require "script.card.soil.card15410"

ccard25410 = class("ccard25410",ccustomcard,{
    sid = 25410,
    race = 5,
    name = "name45",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 2,
    shield = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 22,
    desc = "你的法术的法力值消耗减少1点",
})

function ccard25410:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25410:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard25410:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard25410
