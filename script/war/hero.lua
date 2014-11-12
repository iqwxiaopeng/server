require "script.base"

chero = class("chero")

function chero:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.maxhp = conf.maxhp
	self.skillcost = conf.skillcost
	self.hp = self.maxhp
	self.atk = 0
end

function 

return chero
