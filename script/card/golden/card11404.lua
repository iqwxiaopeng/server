--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11404 = class("ccard11404",ccustomcard,{
    sid = 11404,
    race = 1,
    name = "法力浮龙",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 3,
    crystalcost = 1,
    targettype = 23,
    desc = "每当你施放一个法术时,便获得+1攻击力",
})

function ccard11404:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11404:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11404:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- war
require "script.war.aux"
require "script.war.warmgr"


function ccard11404:__onadd()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"onplaycard",self.id)
end

function ccard11404:__ondel()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onplaycard",self.id)
end

function ccard11404:__onplaycard(warcard,target)
	if is_magiccard(warcard.type) then
		self:addbuff({addatk = 1,},self.id)
	end
end

return ccard11404
