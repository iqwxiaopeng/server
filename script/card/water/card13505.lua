--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13505 = class("ccard13505",ccustomcard,{
    sid = 13505,
    race = 3,
    name = "北郡牧师",
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
    type = 201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "每当一个随从获得治疗时,抽1张牌。",
})

function ccard13505:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13505:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13505:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard13505
