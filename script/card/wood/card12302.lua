--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12302 = class("ccard12302",ccustomcard,{
    sid = 12302,
    race = 2,
    name = "生而平等",
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
    crystalcost = 2,
    targettype = 32,
    desc = "将所有随从的生命值变为1。",
})

function ccard12302:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12302:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12302:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12302:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.footman:addbuff({setmaxhp=1,},self.id,self.sid)
	warobj.enemy.footman:addbuff({setmaxhp=1,},self.id,self.sid)
end

return ccard12302
