--<<card 导表开始>>
require "script.card"
ccard16304 = class("ccard16304",ccard,{
    sid = 16304,
    race = 6,
    name = "name29",
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

function ccard16304:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16304:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard16304:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
