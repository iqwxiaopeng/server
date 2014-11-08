require "script.base"

cwarcard = class("cwarcard")

function cwarcard:init(id,sid)
	self.id = id
	self.sid = sid
	self.beginround_effects = {}
	self.endround_effects = {}
	self.warcry_effects = {}
	self.alive_effects = {}
	self.die_effects = {}
	self.pos = nil
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
