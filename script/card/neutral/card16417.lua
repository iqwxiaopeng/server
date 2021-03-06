--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16417 = class("ccard16417",ccustomcard,{
    sid = 16417,
    race = 6,
    name = "苦痛寺僧",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "每当该随从受到伤害时,抽一张牌。",
})

function ccard16417:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16417:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16417:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16417:onhurt(hurtvalue,srcid)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)
end

return ccard16417
