--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16205"

ccard26205 = class("ccard26205",ccustomcard,{
    sid = 26205,
    race = 6,
    name = "熔合巨人",
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
    atk = 8,
    hp = 8,
    crystalcost = 20,
    targettype = 0,
    desc = "你的英雄每受到1点伤害,这张牌的法力值消耗便减少（1）点。",
})

function ccard26205:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26205:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26205:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26205
