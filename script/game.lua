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
require "script.war.aux"

game = game or {}
function game.startgame()
	print("Startgame...",playermgr)
	console.init()
	logger.init()
	db.init()
	globalmgr.init()
	net.init()
	proto.init()
	playermgr.init()
	print("ok1")
	cluster.init()
	print("ok2")
	timectrl.init()
	gm.init()
	oscmd.init()
	waraux.init()
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
