--<<card 导表开始>>
require "script.card"
ccard12307 = class("ccard12307",ccard,{
    sid = 12307,
    race = 2,
    name = "name32",
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

function ccard12307:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12307:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard12307:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
