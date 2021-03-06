--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16431"

ccard26431 = class("ccard26431",ccustomcard,{
    sid = 26431,
    race = 6,
    name = "恐怖海盗",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 204,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 3,
    crystalcost = 4,
    targettype = 0,
    desc = "嘲讽。消耗降低,降低数值相当于你的武器攻击。",
})

function ccard26431:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26431:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26431:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26431
