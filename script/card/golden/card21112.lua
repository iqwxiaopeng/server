--<<card 导表开始>>
require "script.card"
ccard21112 = class("ccard21112",ccard,{
    sid = 21112,
    race = 1,
    name = "name12",
    magic_immune = 0,
    dieeffect = 0,
    assault = 0,
    buf = 0,
    warcry = 0,
    lifecircle = 1000,
    sneer = 0,
    magic = 0,
    magic_hurt = 0,
    max_amount = 1,
})

function ccard21112:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard21112:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard21112:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
