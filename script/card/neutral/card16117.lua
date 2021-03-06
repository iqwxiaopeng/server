--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16117 = class("ccard16117",ccustomcard,{
    sid = 16117,
    race = 6,
    name = "霍格",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 4,
    crystalcost = 6,
    targettype = 0,
    desc = "在你的回合结束时,召唤一个2/2并具有嘲讽的豺狼人。",
})

function ccard16117:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16117:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16117:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16117:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.warcards < WAR_CARD_LIMIT then
		local cardsid = isprettycard(self.sid) and 26621 or 16621
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard,self.pos)
	end

end

return ccard16117
