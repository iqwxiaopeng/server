--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12101"

ccard22101 = class("ccard22101",ccustomcard,{
    sid = 22101,
    race = 2,
    name = "提里奥·弗丁",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 1,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 8,
    targettype = 23,
    desc = "圣盾,嘲讽,亡语：装备一把5/3的灰烬使者。",
})

function ccard22101:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22101:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22101:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22101
