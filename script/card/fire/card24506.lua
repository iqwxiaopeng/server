--<<card 导表开始>>
local ccustomcard = require "script.card.fire.card14506"

ccard24506 = class("ccard24506",ccustomcard,{
    sid = 24506,
    race = 4,
    name = "苔原犀牛",
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "使你的野兽获得冲锋。",
})

function ccard24506:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24506:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard24506:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard24506
