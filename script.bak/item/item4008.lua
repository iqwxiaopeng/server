--<<item 导表开始>>
require "script.item"
citem4008 = class("citem4008",citem)
function citem4008:init(id)
    citem.init(self,id)
    self.sid = 4008
    self.name = "name43"
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
function citem4008:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem4008:save()
    local data = {}
    -- todo: save data
    return data
end
