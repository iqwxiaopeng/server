local key,val = KEYS[1],ARGV[1]
assert(key)
assert(val)
local exist = redis.call('get',key)
if not exist then
	redis.call('set',key,val)
end
