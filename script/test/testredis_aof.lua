local skynet = require "skynet"
local redis = require "redis"

local conf = {
	host = "127.0.0.1",
	port = 6800,
	db = 0,
	auth = "foobared",
}

local function difftime(starttime)
	return os.clock() - starttime
end

skynet.start(function (...)
	print "start"
	local db = redis.connect(conf)
	local starttime = os.clock()
	for i = 1, 100000000 do
		db:set("key"..i,"value"..i)
	end
	print("set costtime:" .. difftime(starttime))
	starttime = os.clock()
	db:bgrewriteaof()
	print("bgrewriteaof costtime:" .. difftime(starttime))
	db:disconnect()
end)

