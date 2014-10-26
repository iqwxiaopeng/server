net = net or {}
function net.init()
	net.test = require "script.net.test"
	net.login = require "script.net.login"
	net.msg = require "script.net.msg"
	net.player = require "script.net.player"
end
return net
