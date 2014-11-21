--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12401"

ccard22401 = class("ccard22401",ccustomcard,{
    sid = 22401,
    race = 2,
    name = "name36",
    magic_immune = 0,
    assault = 1,
    sneer = 0,
    atkcnt = 2,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    type = 0,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 1,
    crystalcost = 1,
    targettype = 33,
    desc = "召唤2个0/2,并具有嘲讽的随从",
})

function ccard22401:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22401:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22401:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22401
