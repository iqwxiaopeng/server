-- [100,200)
local proto = {}
proto.c2s = [[

]]

proto.s2c = [[
msg_notify 100 {
	request {
		msg 0 : string
	}
}

]]
