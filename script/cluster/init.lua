local skynet = require "skynet"
local skynet_cluster = require "cluster"

cluster = cluster or {}

function cluster.init()
	local clusterkey = skynet.getenv("clusterkey")
	skynet_cluster.open(clusterkey)
end

function cluster.call(node,address,...)
	skynet_cluster.call(node,address,...)
end

return cluster


