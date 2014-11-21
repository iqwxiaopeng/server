--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11510 = class("ccard11510",ccustomcard,{
    sid = 11510,
    race = 1,
    name = "烈焰风暴",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 1101,
    magic_hurt = 4,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 7,
    targettype = 0,
    desc = "对所有敌方随从造成4点伤害",
})

function ccard11510:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11510:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11510:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11510:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = ccard11510.magic_hurt + warobj:get_addition_magic_hurt()
	warobj.enemy.footman:addhp(-hurtvalue,self.id)
end

return ccard11510
