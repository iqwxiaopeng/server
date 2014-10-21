local net = require "script.net"
--local clientsocket = require "clientsocket"
local playermgr = require "script.playermgr"

local request = net.login.REQEUST
print("test_login")

function test()
	local conf = {
		ip = "127.0.0.1",
		port = 8888,
	}
	local fd = assert(clientsocket.connect(conf.ip,conf.port)	)
	local obj = playermgr.getobjectbyfd(fd)
	local accountname = "testaccount"
	local passwd = "hello"
	local result = request.register(obj,{
		account = accountname,
		passwd = passwd,
		srvname = "gs1",
	})
	print("register:",result)
	if result == "200 Ok" then
		result = request.createrole(obj,{
			roletype = 10001,
			name = "name1",
		})
		print("createrole:",result)
		if result == "200 Ok" then
			result = request.login(obj,{
				account = accountname,
				passwd = passwd,
			})
			pprintf("login:%s",result)
			if result.result == "200 Ok" then
				local roles = result.roles
				assert(#roles > 0,"havn't role")
				result = request.entergame(obj,{
					roleid = roles[0],
				})
				pprintf("entergame:%s",result)
				print("entergame ok")
			end
		end
	end
	
end

return test
