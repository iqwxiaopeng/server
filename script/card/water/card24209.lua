--<<card 导表开始>>
require "script.card"
ccard24209 = class("ccard24209",ccard,{
    sid = 24209,
    race = 4,
    name = "name24",
    magic_immune = 0,
    dieeffect = 0,
    assault = 0,
    buf = 0,
    warcry = 0,
    lifecircle = 1000,
    sneer = 0,
    magic = 0,
    magic_hurt = 0,
    max_amount = 2,
})

function ccard24209:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard24209:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard24209:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
