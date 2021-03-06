--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16608"

ccard26608 = class("ccard26608",ccustomcard,{
    sid = 26608,
    race = 6,
    name = "伊瑟拉的觉醒",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 5,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "对除了伊瑟拉以外的全部角色造成5点伤害",
})

function ccard26608:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26608:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26608:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26608
