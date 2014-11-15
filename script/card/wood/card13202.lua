--<<card 导表开始>>
require "script.card"
ccard13202 = class("ccard13202",ccard,{
    sid = 13202,
    race = 3,
    name = "name18",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 2,
    shield = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
})

function ccard13202:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13202:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard13202:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
