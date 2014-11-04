--<<card 导表开始>>
require "script.card"
ccard26201 = class("ccard26201",ccard,{
    sid = 26201,
    race = 6,
    name = "name16",
    magic_immune = 0,
    dieeffect = 0,
    assault = 1,
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

function ccard26201:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26201:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard26201:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
