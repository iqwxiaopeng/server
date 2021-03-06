--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16205 = class("ccard16205",ccustomcard,{
    sid = 16205,
    race = 6,
    name = "熔合巨人",
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
    atk = 8,
    hp = 8,
    crystalcost = 20,
    targettype = 0,
    desc = "你的英雄每受到1点伤害,这张牌的法力值消耗便减少（1）点。",
})

function ccard16205:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16205:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16205:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16205:onputinhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj.hero,"onhurt",self.id)
	register(warobj.hero,"onaddhp",self.id)
end

function ccard16205:onremovefromhand()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj.hero,"onhurt",self.id)
	unregister(warobj.hero,"onaddhp",self.id)
end

function ccard16205:__onhurt(target,hurtvalue,srcid)
	self:addbuff({addcrystalcost=-hurtvalue},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

function ccard16205:__onaddhp(target,recoverhp)
	self:addbuff({addcrystalcost=recoverhp,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end


return ccard16205
