--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12206"

ccard22206 = class("ccard22206",ccustomcard,{
    sid = 22206,
    race = 2,
    name = "name21",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 33,
    desc = "对一个角色造成3点伤害,并使其冻结",
})

function ccard22206:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22206:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22206:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22206