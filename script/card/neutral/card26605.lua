--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16605"

ccard26605 = class("ccard26605",ccustomcard,{
    sid = 26605,
    race = 6,
    name = "机械幼龙",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 2,
    hp = 1,
    crystalcost = 2,
    targettype = 0,
    desc = "None",
})

function ccard26605:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26605:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26605:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26605
