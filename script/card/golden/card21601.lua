--<<card 导表开始>>
local ccustomcard = require "script.card.golden.card11601"

ccard21601 = class("ccard21601",ccustomcard,{
    sid = 21601,
    race = 1,
    name = "镜像",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    multiatk = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
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

function ccard21601:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21601:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21601:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21601
