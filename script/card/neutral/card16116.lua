--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard16116 = class("ccard16116",ccustomcard,{
    sid = 16116,
    race = 6,
    name = "伊利丹·怒风",
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
    type = 201,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 7,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "每当你使用一张牌时,召唤一个2/1的埃辛诺斯烈焰。",
})

function ccard16116:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16116:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16116:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16116
