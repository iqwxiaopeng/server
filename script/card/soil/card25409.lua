--<<card 导表开始>>
require "script.card"
ccard25409 = class("ccard25409",ccard,{
    sid = 25409,
    race = 5,
    name = "name44",
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
    targettype = 23,
    desc = "当你的对手打出一张随从牌时,召唤一个该随从的复制",
})

function ccard25409:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25409:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard25409:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard25409
