require "script.base"
require "script.gm"
require "script.net"

gmother = gmother or {}

--- usage: echo msg
function gmother.echo(args)
	local ok,result = checkargs(args,"string")
	if not ok then
		net.msg.notify(master.pid,"usage: echo msg")
		return
	end
	local msg = table.unpack(result)
	print("length:",#msg)
	net.msg.notify(master.pid,msg)
end

return gmother
