--<<card 导表开始>>
require "script.card"
ccard14108 = class("ccard14108",ccard,{
    sid = 14108,
    race = 4,
    name = "name8",
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

function ccard14108:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14108:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard14108:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
