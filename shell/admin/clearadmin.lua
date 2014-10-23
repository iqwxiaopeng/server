local key = KEYS[1]
asssert(key)
redis.call(del,key)
