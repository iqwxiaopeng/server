require "script.playermgr"
require "script.proto"
require "script.db"
require "script.timectrl"
require "script.logger"
require "script.net"
require "script.console"
require "script.gm"
require "script.oscmd"

local game = {}
function game.startgame()
	print("Startgame...",playermgr)
	logger.init()
	net.init()
	proto.init()
	db.init()
	playermgr.init()
	timectrl.init()
	console.init()
	gm.init()
	oscmd.init()
	print("Startgame ok")
	logger.log("info","game","startgame")
end

function game.gameover()
	print("Gameover")
	logger.log("info","game","gameover")
end

return game
