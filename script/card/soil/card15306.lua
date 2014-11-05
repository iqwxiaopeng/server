--<<card 导表开始>>
require "script.card"
ccard15306 = class("ccard15306",ccard,{
    sid = 15306,
    race = 5,
    name = "name31",
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
    composechip = 100,
    decomposechip = 10,
})

function ccard15306:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15306:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15306:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
