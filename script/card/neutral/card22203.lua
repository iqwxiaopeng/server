--<<card 导表开始>>
local ccustomcard = require "script.card.wood.card12203"

ccard22203 = class("ccard22203",ccustomcard,{
    sid = 22203,
    race = 6,
    name = "鱼人领军",
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
    type = 203,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "所有其他鱼人获得+2/+1。",
})

function ccard22203:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard22203:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard22203:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard22203
