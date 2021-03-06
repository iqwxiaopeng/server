--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12504 = class("ccard12504",ccustomcard,{
    sid = 12504,
    race = 2,
    name = "愤怒之锤",
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
    magic_hurt = 3,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 33,
    desc = "造成3点伤害,抽一张牌。",
})

function ccard12504:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12504:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12504:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12504:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = self:gethurtvalue()
	target:addhp(-hurtvalue,self.id)
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)
end

return ccard12504
