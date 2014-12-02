--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12101 = class("ccard12101",ccustomcard,{
    sid = 12101,
    race = 2,
    name = "提里奥·弗丁",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 1,
    shield = 1,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 8,
    targettype = 23,
    desc = "圣盾,嘲讽,亡语：装备一把5/3的灰烬使者。",
})

function ccard12101:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12101:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12101:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12101:register()
	register(self,"ondie",self.id)
end

function ccard12101:unregister()
	unregister(self,"ondie",self.id)
end

function ccard12101:__ondie(warcard)
	if warcard ~= self then
		return
	end
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	-- todo : modify
	warobj.hero:equipweapon({})
end

return ccard12101
