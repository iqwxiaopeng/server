local redis = require "redis"
local cjson = require "cjson"
cjson.encode_sparse_array(true)

db = db or {}

local conf = {
	host = "127.0.0.1",
	port = 6800,
	auth = "sundream",
	db = 0,
}
function db.connect(conf)
	-- test
	local skynet = require "skynet"
	local servername = skynet.getenv("servername")
	if servername == "frdsrv" then
		conf.db = 1
	end
	db.conn = redis.connect(conf)	
	return db.conn
end

function db.disconnect()
	db.conn:disconnect()
	db.conn = nil
end

function db.save()
	db.conn:bgsave()
end

function db.key(...)
	local args = {...}
	local ret = args[1] -- tblname
	for i = 2,#args do
		ret = ret .. ":" .. tostring(args[i])
	end
	return ret
end

function db.get(key,default)
	local value = db.conn:get(key)
	if value then
		value = cjson.decode(value)
	else
		value = default
	end
	return value
end

db.query = db.get

function db.set(key,value)
	if value then
		value = cjson.encode(value)
		return db.conn:set(key,value)
	end
end

function db.delete(key)
	return db.conn:del(key)
end

function db.init()
	if db.conn then
		print "Already init"
		return
	end
	db.conn = db.connect(conf)
end
return db
