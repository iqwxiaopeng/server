--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard12203 = class("ccard12203",ccustomcard,{
    sid = 12203,
    race = 2,
    name = "复仇之怒",
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
    magic_hurt = 8,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 6,
    targettype = 23,
    desc = "造成8点伤害,随机分配给敌方角色。",
})

function ccard12203:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12203:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12203:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

require "script.war.aux"
require "script.war.warmgr"

function ccard12203:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	local hitids = {}
	table.insert(hitids,enemy.hero.id)
	for i,id in ipairs(enemy.warcards) do
		table.insert(hitids,id)
	end
	local num = self:gethurtvalue()
	local hurtvalue = num > 0 and 1 or -1
	for i = 1,num do
		if warmgr.isgameover(self.warid) then
			return
		end
		if #hitids == 0 then
			break
		end
		local id,pos = randlist(hitids)	
		local target = warobj:gettarget(id)
		target:addhp(-hurtvalue,self.id)
		if target:isdie() then
			table.remove(hitids,pos)
		end
	end
end

return ccard12203
