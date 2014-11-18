--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11501 = class("ccard11501",ccustomcard,{
    sid = 11501,
    race = 1,
    name = "变形术",
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
    crystalcost = 4,
    targettype = 22,
    desc = "将一个仆从变成一个1/1的羊",
})

function ccard11501:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11501:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11501:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11501:use(target)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(target.id)
	local pos = target.pos
	local cardsid = is_prettycard(target.sid) and 21602 or 11602
	local warcard = owner:newwarcard(cardsid)
	owner:delfootman(target)
	owner:addfootman(warcard,pos)
	
end

return ccard11501
