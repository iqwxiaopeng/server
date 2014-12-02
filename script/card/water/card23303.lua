--<<card 导表开始>>
local ccustomcard = require "script.card.water.card13303"

ccard23303 = class("ccard23303",ccustomcard,{
    sid = 23303,
    race = 3,
    name = "群体驱散",
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
    crystalcost = 4,
    targettype = 0,
    desc = "沉默所有敌方随从,抽一张牌。",
})

function ccard23303:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23303:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard23303:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard23303
