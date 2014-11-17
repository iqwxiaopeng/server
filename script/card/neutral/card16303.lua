--<<card 导表开始>>
require "script.card"
ccard16303 = class("ccard16303",ccard,{
    sid = 16303,
    race = 6,
    name = "name28",
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
    targettype = 23,
    desc = "每当你施放一个法术时,将一张‘火球术’置入你的手牌",
})

function ccard16303:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16303:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16303:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard16303
