--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16520 = class("ccard16520",ccustomcard,{
    sid = 16520,
    race = 6,
    name = "银背族长",
    magic_immune = 0,
    assault = 0,
    sneer = 1,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 4,
    crystalcost = 3,
    targettype = 0,
    desc = "嘲讽",
})

function ccard16520:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16520:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16520:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16520
