require "script.base"

ctarget = class("ctarget")

function ctarget:init(conf)
	self.pid = conf.pid
	self.bufs = {}
	self.state = {}
	self.onhurt = {}
	self.ondie = {}
	self.ondefense = {}
	self.onattack = {}
end

function ctarget:addbuf(value,srcid)
end

function ctarget:delbuf(srcid)
end

function ctarget:addhp(value,srcid)
end

function ctarget:addatk(value,srcid)
end

function ctarget:addcrystal(value,srcid)
end

function ctarget:sethp(value,srcid)
end

function ctarget:setatk(value,srcid)
end

function ctarget:setcrystal(value,srcid)
end

return ctarget
