--<<card 导表开始>>
local ccustomcard = require "script.card"

ccard15301 = class("ccard15301",ccustomcard,{
    sid = 15301,
    race = 5,
    name = "星辰坠落",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 0,
    desc = "抉择：对一个随从造成5点伤害；或者对所有敌方随从造成2点伤害。",
})

function ccard15301:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15301:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15301:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end

return ccard15301
