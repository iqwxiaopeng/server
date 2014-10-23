--<<item 导表开始>>
require "script.item"
citem8 = class("citem8",citem)
function citem8:init(pid)
    citem.init(self,pid)
    self.sid = 8
    self.name = "name8"
    self.magic_immune = 0,
    self.dieeffect = 0,
    self.assault = 0,
    self.buf = 0,
    self.warcry = 0,
    self.lifecircle = 1000,
    self.sneer = 0,
    self.magic = 0,
    self.magic_hurt = 0,
    self.max_mount = 1,
    self.data = {}
--<<item 导表结束>>

end --导表生成
function citem8:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem8:save()
    local data = {}
    -- todo: save data
    return data
end
