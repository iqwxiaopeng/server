--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16624"

ccard26624 = class("ccard26624",ccustomcard,{
    sid = 26624,
    race = 6,
    name = "导航小鸡",
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
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "在你的回合开始阶段,消灭该随从,并抽3张牌。",
})

function ccard26624:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26624:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26624:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26624
