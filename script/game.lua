local playermgr = require "script.playermgr"
local proto = require "script.proto"
local db = require "script.db"
local timectrl = require "script.timectrl"
local logger = require "script.logger"
local net = require "script.net"
local console = require "script.console"
local gm = require "script.gm"

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
	print("Startgame ok")
	logger.log("info","game","startgame")
end

function game.gameover()
	print("Gameover")
	logger.log("info","game","gameover")
end

return game
