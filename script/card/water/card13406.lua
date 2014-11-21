--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13406 = class("ccard13406",ccustomcard,{
    sid = 13406,
    race = 3,
    name = "name42",
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
    desc = "当你的对手打出一张随从牌时,召唤一个该随从的复制",
})

function ccard13406:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13406:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13406:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard13406