--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16110"

ccard26110 = class("ccard26110",ccustomcard,{
    sid = 26110,
    race = 6,
    name = "纳克·伯格",
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
    atk = 0,
    hp = 4,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,你有50%的几率额外抽一张牌。",
})

function ccard26110:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26110:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26110:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26110
