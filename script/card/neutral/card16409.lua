--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16409 = class("ccard16409",ccustomcard,{
    sid = 16409,
    race = 6,
    name = "荆棘谷猛虎",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 1,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "潜行",
})

function ccard16409:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16409:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16409:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16409
