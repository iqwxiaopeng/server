--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11406 = class("ccard11406",ccustomcard,{
    sid = 11406,
    race = 1,
    name = "巫师学徒",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 23,
    desc = "你的法术的法力值消耗减少1点",
})

function ccard11406:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11406:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11406:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11406:register()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.magic_handcard:addhalo({addcrystalcost=-1},self.id)
end

function ccard11406:unregister()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.magic_handcard:delhalo(self.id)
end

function ccard11406:use(target)
end

return ccard11406
