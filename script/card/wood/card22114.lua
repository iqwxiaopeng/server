--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12114"

ccard22114 = class("ccard22114",ccustomcard,{
    sid = 22114,
    race = 2,
    name = "name14",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 23,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard22114:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22114:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22114:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22114
