--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11305 = class("ccard11305",ccustomcard,{
    sid = 11305,
    race = 1,
    name = "蒸发",
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
    targettype = 0,
    desc = "奥秘：当一个随从攻击你英雄时,将其消灭",
})

function ccard11305:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11305:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11305:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
function ccard11305:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	warobj.hero:register("ondefense",self.id)
end

local heroevent = {}
ccard11305.hero = heroevent

function heroevent:__ondefense(attacker)
	if is_footman(attacker.type) then
		warobj:delsecret(self.id)
		warobj.hero:unregister("ondefense",self.id)
		attacker:suicide()
		return true
	end
	return false
end

return ccard11305
