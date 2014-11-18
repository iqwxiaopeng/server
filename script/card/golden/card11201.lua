--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11201 = class("ccard11201",ccustomcard,{
    sid = 11201,
    race = 1,
    name = "寒冰屏障",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 11,
    desc = "奥秘：当你的英雄将要承受致命伤害时,防止这些伤害,并使其在本回合免疫",
})

function ccard11201:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11201:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11201:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"


local heroevent = {}
ccard11201.hero = heroevent
function heroevent:__ondefense(hurtvalue)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hero = warobj.hero
	if hero:gethp() <= hurtvalue then
		hero:setstate("immune",1)
		warobj:delsecret(self.id)	
		unregister(warobj.hero,"ondefense",self.id)
	end
end

function ccard11201:use(target)
	local war = warmgr.getwar(self.warid)	
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

return ccard11201
