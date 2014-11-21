--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16601 = class("ccard16601",ccustomcard,{
    sid = 16601,
    race = 6,
    name = "幸运币",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 6101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 0,
    desc = "addcrystal",
})

function ccard16601:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16601:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16601:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16601
