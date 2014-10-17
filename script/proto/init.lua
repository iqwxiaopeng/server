sproto = require "sproto"
local net = require "script.net"

local proto = {}

function proto.register(protoname)
	local protomod = require("script.proto." .. protoname)
	proto.s2c = proto.s2c .. protomod.s2c
	proto.c2s = proto.c2s .. protomod.c2s
end

function proto.init()
	proto.s2c = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	proto.c2s = [[
.package {
	type 0 : integer
	session 1 : integer
}
]]
	for protoname,netmod in pairs(net) do
		proto.register(protoname)
	end
	local lineno
	local b,e
	print("s2c:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.s2c,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(proto.s2c,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
	print("c2s:")
	lineno = 1
	b = 1
	while true do
		e = string.find(proto.c2s,"\n",b)
		if not e then
			break
		end
		print(lineno,string.sub(proto.c2s,b,e-1))
		b = e + 1
		lineno = lineno + 1
	end
	proto.host = sproto.parse(proto.s2c):host "package"
	proto.request = proto.host:attach(sproto.parse(proto.c2s))
end
return proto
