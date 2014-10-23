--<<item 导表开始>>
require "script.item"
citem2004 = class("citem2004",citem)
function citem2004:init(id)
    citem.init(self,id)
    self.sid = 2004
    self.name = "name29"
    self.magic_immune = 0,
    self.dieeffect = 0,
    self.assault = 0,
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
function citem2004:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem2004:save()
    local data = {}
    -- todo: save data
    return data
end
