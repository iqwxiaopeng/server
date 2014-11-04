--<<card 导表开始>>
require "script.card"
ccard23308 = class("ccard23308",ccard,{
    sid = 23308,
    race = 3,
    name = "name34",
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

function ccard23308:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard23308:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard23308:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
