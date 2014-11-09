require "script.base"

cwarcard = class("cwarcard")

function cwarcard:init(id,sid)
	self.id = id
	self.sid = sid
	self.effects = {}
end

function cwarcard:push_effect(effect)
	table.insert(self.effects,effect)
end

return cwarcard
