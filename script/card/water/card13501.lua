--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard13501 = class("ccard13501",ccustomcard,{
    sid = 13501,
    race = 3,
    name = "精神控制",
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
    crystalcost = 10,
    targettype = 22,
    desc = "获得一个敌方随从的控制权。",
})

function ccard13501:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13501:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13501:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13501:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	assert(warobj.id_card[target.id],"Invalid targetid:" .. tostring(target.id))
	warobj:removefromwar(target)
	local warcard = warobj:clone(target)
	warobj:putinwar(warcard)
end

return ccard13501
