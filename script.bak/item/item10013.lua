--<<item 导表开始>>
require "script.item"
citem10013 = class("citem10013",citem)
function citem10013:init(id)
    citem.init(self,id)
    self.sid = 10013
    self.name = "name13"
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
function citem10013:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem10013:save()
    local data = {}
    -- todo: save data
    return data
end
