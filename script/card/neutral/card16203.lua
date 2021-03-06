--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16203 = class("ccard16203",ccustomcard,{
    sid = 16203,
    race = 6,
    name = "鱼人领军",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "所有其他鱼人获得+2/+1。",
})

function ccard16203:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16203:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16203:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16203:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local halo = {addatk=2,addmaxhp=1,}
	warobj.fish_footman:addhalo(halo,self.id,self.sid)
	warobj.enemy.fish_footman:addhalo(halo,self.id,self.sid)
end

function ccard16203:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj.fish_footman:delhalo(self.id)
	warobj.enemy.fish_footman:delhalo(self.id)
end

return ccard16203
