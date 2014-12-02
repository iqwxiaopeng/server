--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12202 = class("ccard12202",ccustomcard,{
    sid = 12202,
    race = 2,
    name = "圣疗术",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 8,
    targettype = 33,
    desc = "恢复8点生命。抽3张牌。",
})

function ccard12202:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12202:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12202:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard12202
