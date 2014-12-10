--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16536 = class("ccard16536",ccustomcard,{
    sid = 16536,
    race = 6,
    name = "机械幼龙技工",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
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
    atk = 2,
    hp = 4,
    crystalcost = 4,
    targettype = 0,
    desc = "战吼：召唤一个2/1的机械幼龙。",
})

function ccard16536:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16536:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16536:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16536:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 26605 or 16605
	local warcard = warobj:newwarcard(cardsid)
	warobj:putinwar(warcard,self.pos+1)
end

return ccard16536
