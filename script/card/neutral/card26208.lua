--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16208"

ccard26208 = class("ccard26208",ccustomcard,{
    sid = 26208,
    race = 6,
    name = "末日预言者",
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
    atk = 0,
    hp = 7,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,消灭所有随从。",
})

function ccard26208:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26208:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26208:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26208
