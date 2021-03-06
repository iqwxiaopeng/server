--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16332 = class("ccard16332",ccustomcard,{
    sid = 16332,
    race = 6,
    name = "年迈的法师",
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
    hp = 5,
    crystalcost = 4,
    targettype = 0,
    desc = "战吼：使相邻的随从获得法术伤害+1。",
})

function ccard16332:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16332:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16332:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16332:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local pos = self.pos
	local id = warobj.warcards[pos-1]
	if id then
		local footman = warobj.id_card[id]
		footman:set_magic_hurt_adden(1)
	end
	id = warobj.warcards[pos+1]
	if id then
		local footman = warobj.id_card[id]
		footman:set_magic_hurt_adden(1)
	end
end

return ccard16332
