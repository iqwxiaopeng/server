--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16413"

ccard26413 = class("ccard26413",ccustomcard,{
    sid = 26413,
    race = 6,
    name = "白银之手骑士",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "战吼：召唤一个2/2的侍从。",
})

function ccard26413:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26413:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26413:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26413
