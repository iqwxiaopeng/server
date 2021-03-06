--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12603"

ccard22603 = class("ccard22603",ccustomcard,{
    sid = 22603,
    race = 2,
    name = "灰烬使者",
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
    type = 301,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 5,
    hp = 3,
    crystalcost = 5,
    targettype = 0,
    desc = "None",
})

function ccard22603:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22603:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22603:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22603
