--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard11503 = class("ccard11503",ccustomcard,{
    sid = 11503,
    race = 1,
    name = "奥术飞弹",
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
    type = 101,
    magic_hurt = 3,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "造成3点伤害,随机分配给敌方角色",
})

function ccard11503:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11503:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11503:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard11503:use(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	local ids = enemy.footman:allid()
	table.insert(ids,enemy.hero.id)
	local hurtvalue = ccard11503.magic_hurt + warobj:get_magic_hurt_adden()
	local hitids = {}
	for i = 1,hurtvalue do
		table.insert(hitids,randlist(ids))
	end
	for _,id in ipairs(hitids) do
		if id == enemy.hero.id then
			enemy.hero:addhp(-1,self.id)
		else
			local warcard = enemy.id_card[id]
			warcard:addhp(-1,self.id)
		end
	end
end

return ccard11503
