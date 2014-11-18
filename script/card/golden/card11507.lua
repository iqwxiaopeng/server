--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11507 = class("ccard11507",ccustomcard,{
    sid = 11507,
    race = 1,
    name = "镜像",
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
    crystalcost = 1,
    targettype = 0,
    desc = "召唤2个0/2,并具有嘲讽的随从",
})

function ccard11507:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11507:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11507:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11507:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i = 1,2 do
		local cardsid = is_prettycard(self.sid) and 21601 or 11601
		local warcard = warobj:newwarcard(cardsid)
		warobj:addfootman(warcard,#warobj.warcards)
	end
end

return ccard11507
