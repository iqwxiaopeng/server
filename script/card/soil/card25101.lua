--<<card 导表开始>>
require "script.card"
ccard25101 = class("ccard25101",ccard,{
    sid = 25101,
    race = 5,
    name = "name1",
    magic_immune = 0,
    dieeffect = 0,
    assault = 1,
    buf = 0,
    warcry = 0,
    lifecircle = 1000,
    sneer = 0,
    magic = 0,
    magic_hurt = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
})

function ccard25101:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard25101:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard25101:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
