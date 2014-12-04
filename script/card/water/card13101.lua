--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13101 = class("ccard13101",ccustomcard,{
    sid = 13101,
    race = 3,
    name = "先知维纶",
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
    atk = 7,
    hp = 7,
    crystalcost = 7,
    targettype = 0,
    desc = "使你的法术牌和英雄技能的伤害和治疗效果翻倍。",
})

function ccard13101:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13101:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13101:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard13101
