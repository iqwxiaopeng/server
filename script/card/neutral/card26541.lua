--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16541"

ccard26541 = class("ccard26541",ccustomcard,{
    sid = 26541,
    race = 6,
    name = "藏宝海湾保镖",
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
    type = 201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 4,
    crystalcost = 5,
    targettype = 0,
    desc = "嘲讽",
})

function ccard26541:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26541:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26541:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26541
