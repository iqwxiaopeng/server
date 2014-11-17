--<<card 导表开始>>
require "script.card"
ccard11405 = class("ccard11405",ccard,{
    sid = 11405,
    race = 1,
    name = "镜像实体",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    multiatk = 1,
    shield = 0,
    type = 1101,
    magic_hurt = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "当你的对手打出一张随从牌时,召唤一个该随从的复制",
})

function ccard11405:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard11405:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard11405:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard11405
