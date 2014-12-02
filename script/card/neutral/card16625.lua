--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16625 = class("ccard16625",ccustomcard,{
    sid = 16625,
    race = 6,
    name = "壮胆机器人3000型",
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
    type = 206,
    magic_hurt = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 4,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的结束阶段,使随机一名仆从获得+1/+1。",
})

function ccard16625:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16625:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16625:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16625
