--<<card 导表开始>>
local ccustomcard = require "script.card.soil.card15406"

ccard25406 = class("ccard25406",ccustomcard,{
    sid = 25406,
    race = 5,
    name = "自然印记",
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
    crystalcost = 3,
    targettype = 32,
    desc = "抉择：使一个随从获得+4攻击力；或者+4生命值并具有嘲讽。",
})

function ccard25406:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25406:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard25406:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard25406
