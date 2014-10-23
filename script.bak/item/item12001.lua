--<<item 导表开始>>
require "script.item"
citem12001 = class("citem12001",citem)
function citem12001:init(id)
    citem.init(self,id)
    self.sid = 12001
    self.name = "name26"
    self.magic_immune = 0,
    self.dieeffect = 0,
    self.assault = 1,
    self.buf = 0,
    self.warcry = 0,
    self.lifecircle = 1000,
    self.sneer = 0,
    self.magic = 0,
    self.magic_hurt = 0,
    self.max_mount = 2,
    self.data = {}
--<<item 导表结束>>

end --导表生成
function citem12001:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem12001:save()
    local data = {}
    -- todo: save data
    return data
end
