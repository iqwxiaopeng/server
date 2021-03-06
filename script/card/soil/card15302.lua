--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard15302 = class("ccard15302",ccustomcard,{
    sid = 15302,
    race = 5,
    name = "滋养",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 0,
    desc = "抉择：获得2个法力水晶；或者抽3张牌。",
})

function ccard15302:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15302:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15302:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15302:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if self.choice == 1 then
		warobj:add_empty_crystal(2)
		
	elseif self.choice == 2 then
		for i = 1,3 do
			local cardsid = warobj:pickcard()
			warobj:putinhand(cardsid)
		end
	end
end

return ccard15302
