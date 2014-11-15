--<<card 导表开始>>
require "script.card"
ccard26210 = class("ccard26210",ccard,{
    sid = 26210,
    race = 6,
    name = "name25",
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

function ccard26210:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26210:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26210:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
