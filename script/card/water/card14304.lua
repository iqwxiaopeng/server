--<<card 导表开始>>
require "script.card"
ccard14304 = class("ccard14304",ccard,{
    sid = 14304,
    race = 4,
    name = "name29",
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
    targettype = 11,
    desc = "奥秘：当你的英雄将要承受致命伤害时,防止这些伤害,并使其在本回合免疫",
})

function ccard14304:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14304:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard14304:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard14304
