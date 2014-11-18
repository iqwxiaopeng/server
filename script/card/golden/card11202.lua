--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11202 = class("ccard11202",ccustomcard,{
    sid = 11202,
    race = 1,
    name = "炎爆术",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 10,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 10,
    targettype = 23,
    desc = "造成10点伤害",
})

function ccard11202:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11202:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11202:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11202:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = ccard11202.magic_hurt + warobj:get_addition_magic_hurt()
	target:addhp(-hurtvalue,self.id)
end

return ccard11202
