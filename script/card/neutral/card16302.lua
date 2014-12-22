--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16302 = class("ccard16302",ccustomcard,{
    sid = 16302,
    race = 6,
    name = "任务达人",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 2,
    crystalcost = 3,
    targettype = 0,
    desc = "每当你使用一张牌时,便获得+1/+1。",
})

function ccard16302:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16302:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16302:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16302:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
end

function ccard16302:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
end

function ccard16302:__onplaycard(warcard,pos,target)
	self:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16302
