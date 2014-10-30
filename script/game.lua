require "script.playermgr"
require "script.proto"
require "script.db"
require "script.timectrl"
require "script.logger"
require "script.net"
require "script.console"
require "script.gm"
require "script.oscmd"
require "script.globalmgr"
require "script.cluster"

game = game or {}
function game.startgame()
	print("Startgame...",playermgr)
	logger.init()
	db.init()
	globalmgr.init()
	net.init()
	proto.init()
	playermgr.init()
	cluster.init()
	timectrl.init()
	console.init()
	gm.init()
	oscmd.init()
	game.initall = true
	print("Startgame ok")
	logger.log("info","game","startgame")
end

function game.gameover()
	game.initall = nil
	print("Gameover")
	logger.log("info","game","gameover")
end

return game
