--<<card 导表开始>>
local ccustomcard = require "script.card.water.card13510"

ccard23510 = class("ccard23510",ccustomcard,{
    sid = 23510,
    race = 3,
    name = "心灵视界",
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
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "随机复制你的对手手牌中的一张牌,将其置入你的手牌。",
})

function ccard23510:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23510:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard23510:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard23510
