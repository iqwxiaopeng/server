require "script.base"

warmgr = warmgr or {}

function warmgr.init()
	warmgr.id_war = {}
end

function warmgr.getwar(warid)
	return warmgr.id_war[warid]
end

function warmgr.addwar(war)
	warmgr.id_war[war.warid] = war
end

function warmgr.delwar(warid)
	warmgr.id_war[warid] = nil
end

return warmgr
