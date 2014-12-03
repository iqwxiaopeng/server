--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11401 = class("ccard11401",ccustomcard,{
    sid = 11401,
    race = 1,
    name = "冰锥术",
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
    type = 101,
    magic_hurt = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 22,
    desc = "冻结一个随从和其相邻随从,并对他们造成1点伤害",
})

function ccard11401:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11401:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11401:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.warmgr"
function ccard11401:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local owner = war:getowner(target.id)
	local lefttarget = owner.warcards[target.pos-1]
	local righttarget = owner.warcards[target.pos+1]
	local hurtvalue = ccard11401.magic_hurt + warobj:get_magic_hurt_adden()
	target:addhp(-hurtvalue,self.id)
	target:setstate("freeze",1)
	if lefttarget then
		lefttarget:addhp(-hurtvalue,self.id)
		lefttarget:setstate("freeze",1)
	end
	if righttarget then
		righttarget:addhp(-hurtvalue,self.id)
		righttarget:setstate("freeze",1)
	end
end

return ccard11401
