netcluster = netcluster or {}

function netcluster.init()
	require "script.server"
	netcluster.route = require "script.cluster.route"
	netcluster.playermethod = require "script.cluster.playermethod"
	netcluster.modmethod = require "script.cluster.modmethod"
	if cserver.isfrdsrv() then
		netcluster.friendmgr = require "script.friend.friendmgr"
	end
end

function __hotfix()
	netcluster.init()
end

return netcluster
