--<<card 导表开始>>
local ccustomcard = require "script.card.neutral.card16611"

ccard26611 = class("ccard26611",ccustomcard,{
    sid = 26611,
    race = 6,
    name = "翡翠巨龙",
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
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 7,
    hp = 6,
    crystalcost = 4,
    targettype = 0,
    desc = "None",
})

function ccard26611:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26611:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26611:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard26611
