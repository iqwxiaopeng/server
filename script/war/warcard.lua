require "script.base"

cwarcard = class("cwarcard")

function cwarcard:init(conf)
	self.id = assert(conf.id)
	self.sid = assert(conf.sid)
	self.warid = assert(conf.warid)
	self.pid = assert(conf.pid)
	self.beginround_effects = {}
	self.endround_effects = {}
	self.warcry_effects = {}
	self.alive_effects = {}
	self.die_effects = {}
	self.pos = nil
	self:initproperty()
	self:registerall()
end

function cwarcard:initproperty()
end

function cwarcard:registerall()
	local war = warmgr.getwar(self.warid)
	local cardcls = getclassbycardsid(self.sid)
	if cardcls.onhurt then
		war:register(self.id,"onhurt")
	end
	if cardcls.onattack then
		war:register(self.id,"onattack")
	end
	if cardcls.on_been_attack then
		war:register(self.id,"on_been_attack")
	end
	if cardcls.ondie then
		war:register(self.id,"ondie")
	end
	if cardcls.on_self_hero_hurt then
		war:register(self.pid,"onhurt")
	end
	if cardcls.on_self_hero_use_card then
		war:register(self.pid,"on_use_card")
	end
	if cardcls:on_self_hero_attack then
		war:register(self.pid,"onattack")
	end
	if cardcls:on_self_hero_been_attack then
		war:register(self.pid,"on_been_attack")
	end
	if cardcls:on_self_hero_equip_weapon then
		war:register(self.pid,"on_equip_weapon")
	end
			

end

local function _push_effect(effects,effect)
	table.insert(effects,effect)
	if effect.type == "silence" then
		effects.start = #effects + 1
	end
end

function cwarcard:push_effect(effect)
	if is_beginround_effect(effect) then
		_push_effect(self.beginround_effects,effect)
	elseif is_endround_effect(effect) then
		_push_effect(self.endround_effects,effect)
	elseif is_warcry_effects(effect) then
		_push_effect(self.warcry_effects,effect)
	elseif is_alive_effects(effect) then
		_push_effect(self.alive_effects,effect)
	elseif is_die_effects(effect) then
		_push_effect(self.die_effects,effect)
	end
end

function cwarcard:onhurt(oldhp,nowhp)
	local aliveeffect = self:getaliveeffect()	
	for targettype,actions do
		for buftype,value in ipairs(actions) do
			if isstate(buftype) then
				if 
			end
		end
	end
end

return cwarcard
