--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16115 = class("ccard16115",ccustomcard,{
    sid = 16115,
    race = 6,
    name = "穆克拉",
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
    type = 202,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 5,
    crystalcost = 3,
    targettype = 0,
    desc = "战吼：使你的对手获得2个香蕉。",
})

function ccard16115:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16115:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16115:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16115
