--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13305 = class("ccard13305",ccustomcard,{
    sid = 13305,
    race = 3,
    name = "光明之泉",
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
    recoverhp = 3,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 5,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,随机为一个受到伤害的友方角色恢复3点生命值。",
})

function ccard13305:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13305:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13305:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard13305
