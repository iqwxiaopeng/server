--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16404"

ccard26404 = class("ccard26404",ccustomcard,{
    sid = 26404,
    race = 6,
    name = "小精灵",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 0,
    targettype = 0,
    desc = "None",
})

function ccard26404:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26404:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26404:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26404
