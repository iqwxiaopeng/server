--<<card 导表开始>>
local ccustomcard = require "script.card.fire.card14303"

ccard24303 = class("ccard24303",ccustomcard,{
    sid = 24303,
    race = 4,
    name = "照明弹",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
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
    desc = "使所有随从失去潜行效果。摧毁敌方所有奥秘。抽1张牌。",
})

function ccard24303:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24303:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard24303:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard24303
