local skynet = require "skynet"
require "script.base"
require "script.net"

local AUTH_SUPERADMIN = 100
local AUTH_ADMIN = 90
local AUTH_PROGRAMER = 80
local AUTH_DESIGNER = 70
local AUTH_NORMAL = 10

gm = gm or {}
master = nil

local function __docmd(player,cmdline)
	local cmd,cmdline = string.match(cmdline,"([%w_]+)%s*(.*)")
	local authority = player:authority()
	if cmd then
		local func
		local need_auth
		for auth,cmds in pairs(gm.CMD) do
			if cmds[cmd] then
				func = cmds[cmd]
				need_auth = auth
				break
			end
		end
		master = player
		if func then
			if authority >= need_auth then
				local args = {}
				if cmdline then
					for arg in string.gmatch(cmdline,"[^%s]+") do
						table.insert(args,arg)
					end
				end
				func(args)
			else
				return string.format("authority not enough(%d < %d)",authority,need_auth)
			end
		else
			if authority >= AUTH_ADMIN then
				func = load(cmdline)
				func()
			else
				return "unknow cmd:" .. tostring(cmd)
			end
		end
		master = nil
		return "success"
	else
		return "cann't parse cmdline:" .. tostring(cmdline)
	end
end

function gm.docmd(player,cmdline)
	local ok,result = pcall(__docmd,player,cmdline)
	if not ok then
		skynet.error(result)
		result = "fail"
	end
	logger.log("info","gm",string.format("#%d(authority=%s) docmd '%s' result=%s",player.pid,player:authority(),cmdline,result))
	net.msg.notify(player,string.format("执行结果:%s",result))
end

--- usage: setauthority pid authority
--- e.g. : setauthority 10001 80 # 将玩家10001权限设置成80(权限范围:[1,100])
function gm.setauthority(args)
	local ok,result = pcall(checkargs,args,"int:[10000,]","int:[1,100]")
	if not ok then
		net.msg.notify(master,"usage: setauthority pid authorit")
		error(result)
	end
	local pid,authority = table.unpack(result)	
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master,string.format("玩家(%d)不在线,无法对其进行此项操作",pid))
		return
	end
	if master.pid == player.pid then
		net.msg.notify(master,"无法给自己设置权限")
		return
	end
	local auth = master:authority()
	local target_auth = player:authority()
	if authority > auth then
		net.msg.notify(matster,string.format("权限不足,设定的权限大于自己拥有的权限(%d>%d)",authority,auth))
	end
	if auth <= target_auth then
		net.msg.notify(master,"权限不足,自身权限没有目标权限高")
		return
	end
	if target_auth == AUTH_SUPERADMIN then
		net.msg.notify(master,"警告:你无法对超级管理员设定权限")
		return
	end
	if authority == AUTH_SUPERADMIN then
		net.msg.notify(master,"警告:你无法将他人设置成超级管理员")
		return
	end
	logger.log("info","authority",string.format("#%d(authority=%d) setauthority,pid=%d authority(%d->%d)",auth,pid,target_auth,authority))
	player:setauthority(authority)
end



function gm.init()
	gm.test = require "script.gm.test"
	gm.helper = require "script.gm.helper"
	gm.card = require "script.gm.card"
	gm.CMD = {
		[AUTH_SUPERADMIN] = {
		},
		[AUTH_ADMIN] = {
			clearcard = gm.card.clearcard,
		},
		[AUTH_PROGRAMER] = {
			test = gm.test.test,
		},
		[AUTH_DESIGNER] = {
		},
		[AUTH_NORMAL] = {
			setauthority = gm.setauthority,
			buildgmdoc = gm.helper.buildgmdoc, 
			addcard = gm.card.addcard,
			delcard = gm.card.delcard,
		},
	}
end


return gm
