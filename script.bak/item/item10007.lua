--<<item 导表开始>>
require "script.item"
citem10007 = class("citem10007",citem)
function citem10007:init(id)
    citem.init(self,id)
    self.sid = 10007
    self.name = "name7"
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
function citem10007:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem10007:save()
    local data = {}
    -- todo: save data
    return data
end
