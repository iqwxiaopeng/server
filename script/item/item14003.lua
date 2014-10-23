--<<item 导表开始>>
require "script.item"
citem14003 = class("citem14003",citem)
function citem14003:init(pid)
    citem.init(self,pid)
    self.sid = 14003
    self.name = "name38"
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
function citem14003:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem14003:save()
    local data = {}
    -- todo: save data
    return data
end
