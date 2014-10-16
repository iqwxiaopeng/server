-- [1,100)
local proto = {}
proto.c2s = [[
login_register 1 {
	request {
		account 0 : string
		passwd 1 : string
		srvname 2 : string
	}
	response {
		result 0 : string #test
	}
}

login_createrole 2 {
	request {
		roletype 0 : integer
		name 1 : string
	}
	response {
		result 0 : string
	}
}

login_login 3 {
	request {
		account 0 : string
		passwd 1 : string
	}
	response {
		result 0 : string
		roles 1 : table
	}
}


login_entergame 3 {
	request {
		roleid 0 : integer
	}
}
]]

proto.s2c = [[
]]
