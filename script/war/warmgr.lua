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

function warmgr.createwar(pid1,pid2)
	-- random attacker/defenser
	if ishit(50,100) then
		pid1,pid2 = pid2,pid1
	end
	local war = cwar.new(pid1,pid2)
	return war
end

return warmgr
