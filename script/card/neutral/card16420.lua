--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16420 = class("ccard16420",ccustomcard,{
    sid = 16420,
    race = 6,
    name = "艾露恩的女祭司",
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
    recoverhp = 4,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 4,
    crystalcost = 6,
    targettype = 0,
    desc = "战吼：为你的英雄恢复4点生命值。",
})

function ccard16420:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16420:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16420:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16420:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local recoverhp = self:getrecoverhp()
	warobj.hero:addhp(recoverhp,self.id)
end

return ccard16420
