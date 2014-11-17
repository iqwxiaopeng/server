--<<card 导表开始>>
require "script.card"
ccard21304 = class("ccard21304",ccard,{
    sid = 21304,
    race = 1,
    name = "肯瑞托法师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1201,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 3,
    crystalcost = 3,
    targettype = 23,
    desc = "战吼：在本回合中你使用的下一个奥秘的法力值消耗为0",
})

function ccard21304:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21304:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21304:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21304
