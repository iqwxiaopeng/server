--<<card 导表开始>>
require "script.card"
ccard11301 = class("ccard11301",ccard,{
    sid = 11301,
    race = 1,
    name = "虚灵奥术师",
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
    atk = 3,
    hp = 3,
    crystalcost = 4,
    targettype = 23,
    desc = "当你在回合结束时控制任何奥秘,该随从便获得+2/+2",
})

function ccard11301:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11301:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11301:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end


--warcard
require "script.war.aux"
require "script.war.warmgr"
function ccard11301:__onadd()
	register(self,"onendround",self.id)
end

function ccard11301:__ondel()
	unregister(self,"onendround",self.id)
end

function ccard11301:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.secretcards > 0 then
		self:addbuff({addatk=2,addmaxhp=2},self.id)
	end
end


return ccard11301
