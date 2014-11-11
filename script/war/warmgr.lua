require "script.base"
require "script.server"
require "script.cluster.clustermgr"

warmgr = warmgr or {}

function warmgr.init()
	warmgr.id_war = {}
	warmgr.num = 0
end

function warmgr.getwar(warid)
	return warmgr.id_war[warid]
end

function warmgr.addwar(war)
	warmgr.id_war[war.warid] = war
	warmgr.num = warmgr.num + 1
end

function warmgr.delwar(warid)
	if warmgr.id_war[warid] then
		warmgr.id_war[warid] = nil
		warmgr.num = warmgr.num - 1
	end
end

function warmgr.createwar(profile1,profile2)
	local war = cwar.new(profile1,profile2)
	return war
end


return warmgr
