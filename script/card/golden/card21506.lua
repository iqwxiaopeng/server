--<<card 导表开始>>
require "script.card"
ccard21506 = class("ccard21506",ccard,{
    sid = 21506,
    race = 1,
    name = "水元素",
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
    atk = 3,
    hp = 6,
    crystalcost = 4,
    targettype = 23,
    desc = "冻结任何受到水元素伤害的角色",
})

function ccard21506:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21506:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21506:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard21506
