--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard15506 = class("ccard15506",ccustomcard,{
    sid = 15506,
    race = 5,
    name = "治疗之触",
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
    recoverhp = 8,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 33,
    desc = "恢复8点生命值。",
})

function ccard15506:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15506:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15506:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15506:onuse(target)
	local recoverhp = self:getrecoverhp()
	target:addhp(recoverhp,self.id)
end

return ccard15506
