--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard15101 = class("ccard15101",ccustomcard,{
    sid = 15101,
    race = 5,
    name = "塞纳留斯",
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
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 8,
    crystalcost = 9,
    targettype = 0,
    desc = "抉择：使你的所有其他随从获得+2/+2；或者召唤2个2/2并具有嘲讽的树人。",
})

function ccard15101:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15101:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15101:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard15101
