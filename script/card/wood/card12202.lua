--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12202 = class("ccard12202",ccustomcard,{
    sid = 12202,
    race = 2,
    name = "name17",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 33,
    desc = "造成6点伤害",
})

function ccard12202:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12202:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12202:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard12202
