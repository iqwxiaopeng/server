local db = require "script.db"

local login = {}
-- c2s
local REQUEST = {}
login.REQUEST = REQUEST

function REQUEST.register(obj,args)
	local account = assert(args.account)
	local passwd = assert(args.passwd)
	local srvname = assert(args.srvname)
	local ac = db.get(db.key("account",account))		
	if ac then
		return {result="201 Account exist"}
	else
		ac = {
			passwd = passwd,
			srvname = srvname,
			createtime = os.date("%Y-%m-%d %H:%M:%S"),
			roles = {},
		}
		db.set(db.key("account",account),ac)
		return {result="200 Ok"}
	end
end

function REQUEST.createrole(obj,args)
	local roletype = assert(args.roletype)
	local name = assert(args.name)
	if not isvalid_roletype(roletype) then
		return {result = "301 Invalid roletype"}
	end
	if not isvalid_name(name) then
		return {result = "302 Invalid name"}
	end
	player = playermgr.createplayer()
	return {result = "200 Ok"}
end

function REQUEST.entergame(obj,args)
	local roleid = assert(args.roleid)
	
	local player = playermgr.getplayer(id) 
	if player then	-- 顶号
		net.msg.notify(player,string.format("您的帐号被%s替换下线",gethideip(obj.__agent.ip)))
		net.msg.notify(obj,string.format("%s的帐号已被你替换下线",gethideip(player.__agent.ip)))
		login.kick(player)
		login.transfer_mark(obj,player)		
	else
		player = playerplayermgr.recoverplayer(roleid)
		playermgr.nettransfer(obj.id,player.id)
	end
	return player:entergame()
end

function REQUEST.login(obj,args)
	local account = assert(args.account)
	local passwd = assert(args.passwd)
	local ac = db.get(db.key("account",account))
	if not ac then
		return {result = "202 Account nonexist"}
	else
		if ac.passwd ~= passwd then
			return {result = "203 Password error"}
		else
			return {result= "200 Ok",roles=ac.roles}
		end
	end
end

local RESPONSE = {}
login.RESPONSE = RESPONSE

return login
