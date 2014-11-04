require "script.base"
require "script.db"
require "script.playermgr"
require "script.net"

netlogin = netlogin or {}
-- c2s
local REQUEST = {}
netlogin.REQUEST = REQUEST

function REQUEST.register(obj,request)
	local account = assert(request.account)
	local passwd = assert(request.passwd)
	local srvname = assert(request.srvname)
	if not isvalid_accountname(account) then
		return {result = "204 Invalid account format",}
	end
	if not isvalid_passwd(passwd) then
		return {result = "205 Invalid password format"}
	end
	-- check srvname
	local ac = db:get(db:key("account",account))		
	if ac then
		return {result="201 Account exist"}
	else
		ac = {
			passwd = passwd,
			srvname = srvname,
			createtime = os.date("%Y-%m-%d %H:%M:%S"),
			roles = {},
		}
		db:set(db:key("account",account),ac)
		return {result="200 Ok"}
	end
end

function REQUEST.createrole(obj,request)
	local account = assert(request.account)
	local roletype = assert(request.roletype)
	local name = assert(request.name)
	if not isvalid_roletype(roletype) then
		return {result = "301 Invalid roletype"}
	end
	if not isvalid_name(name) then
		return {result = "302 Invalid name"}
	end
	local ac = db:get(db:key("account",account))
	assert(ac,"Account nonexist")
	local player = playermgr.createplayer()
	if not player then
		return {result = "303 Over limit"}
	end
	player:create(request)	
	local newrole = {
		pid = player.pid,
		name = name,
		roletype = roletype,
	}
	table.insert(ac.roles,newrole)
	db:set(db:key("account",account),ac)	
	player:nowsave()
	return {result = "200 Ok",newrole=newrole}
end

function REQUEST.login(obj,request)
	local account = assert(request.account)
	local passwd = assert(request.passwd)
	local ac = db:get(db:key("account",account))
	if not ac then
		return {result = "202 Account nonexist"}
	else
		if ac.passwd ~= passwd then
			return {result = "203 Password error"}
		else
			obj.account = account
			obj.passwd = passwd
			return {result= "200 Ok",roles=ac.roles}
		end
	end
end

function REQUEST.entergame(obj,request)
	local roleid = assert(request.roleid)
	
	local oldplayer = playermgr.getplayer(roleid) 
	if oldplayer then	-- 顶号
		net.msg.notify(oldplayer.pid,string.format("您的帐号被%s替换下线",gethideip(obj.__ip)))
		net.msg.notify(obj.pid,string.format("%s的帐号已被你替换下线",gethideip(oldplayer.__ip)))
		netlogin.kick(oldplayer)
		if obj ~= oldplayer then
			-- nettransfer will delete obj
			playermgr.delobject(oldplayer.pid,"replace")
		end

	end
	player = playermgr.recoverplayer(roleid)
	netlogin.transfer_mark(obj,player)
	playermgr.nettransfer(obj,player)
	return player:entergame()
end

function REQUEST.exitgame(player) 
	player:exitgame()
end



local RESPONSE = {}
netlogin.RESPONSE = RESPONSE


function netlogin.transfer_mark(obj1,obj2)
	obj2.account = obj1.account
	obj2.passwd = obj1.passwd
end

function netlogin.kick(pid)
	sendpackage(pid,"login","kick")
end

return netlogin
