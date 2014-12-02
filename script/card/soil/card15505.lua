--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard15505 = class("ccard15505",ccustomcard,{
    sid = 15505,
    race = 5,
    name = "爪击",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    crystalcost = 1,
    targettype = 0,
    desc = "使你的英雄获得2点护甲值,并在本回合中获得+2攻击力。",
})

function ccard15505:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15505:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15505:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard15505
