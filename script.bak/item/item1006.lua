--<<item 导表开始>>
require "script.item"
citem1006 = class("citem1006",citem)
function citem1006:init(id)
    citem.init(self,id)
    self.sid = 1006
    self.name = "name21"
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
function citem1006:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem1006:save()
    local data = {}
    -- todo: save data
    return data
end
