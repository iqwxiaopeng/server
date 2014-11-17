--<<card 导表开始>>
require "script.card"
ccard11601 = class("ccard11601",ccard,{
    sid = 11601,
    race = 1,
    name = "镜像",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    multiatk = 1,
    shield = 0,
    type = 1201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 2,
    crystalcost = 0,
    targettype = 23,
    desc = "None",
})

function ccard11601:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11601:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11601:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard11601