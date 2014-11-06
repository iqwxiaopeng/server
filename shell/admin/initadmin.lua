local conf = {
	ip = "127.0.0.1",
	port = 6800,
	auth = "sundream",
}

-- 帐号表和玩家表结构变化时需要跟着变
local admins = {
	{
		account = {
			account = "superman",
			data = {
				createtime = os.date("%Y-%m-%d %H:%M:%S"),
				passwd = "superman",
				roles = {
					{
						pid = 1,
						name = "superman",
						roletype = 1001,
					}
				},
				srvname = "gs",
			},
		},
		role = {
			roleid = 1,	
			data = {
				data = {
					gold = 1000,
					name = "superman",
					roletype = 1001,
					auth = 100,
				}
			},
		},
	},

	{
		account = {
			account = "superman2",
			data = {
				createtime = os.date("%Y-%m-%d %H:%M:%S"),
				passwd = "superman",
				roles = {
					{
						pid = 2,
						name = "superman2",
						roletype = 1001,
					}
				},
				srvname = "gs",
			}			
		},
		role = {
			roleid = 2,
			data = {
				data = {
					gold = 1000,
					name = "superman2",
					roletype = 1001,
					auth = 90,
				},
			},
		},
	},
}

local cjson = require "cjson"
cjson.encode_sparse_array(true)

function escape(str)
	return str
end

for _,admin in pairs(admins) do
	local key,val
	key = string.format("account:%s",admin.account.account)
	val = cjson.encode(admin.account.data)
	val = escape(val)
	--print(val)
	os.execute(string.format("redis-cli -p %s -a %s --eval createadmin.lua '%s' , '%s'",conf.port,conf.auth,key,val))
	key = string.format("role:%s:data",admin.role.roleid)
	val = cjson.encode(admin.role.data)
	val = escape(val)
	os.execute(string.format("redis-cli -p %s -a %s --eval createadmin.lua '%s' , '%s'",conf.port,conf.auth,key,val))
end
