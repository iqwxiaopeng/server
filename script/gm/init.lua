require "script.base"
local net = require "script.net"
local helper = require "script.gm.helper"


local gm = {}
local master = nil

local function __docmd(player,cmdline)
	local cmd,cmdline = string.match("([%w_])+%s(.*))")
	local authority = player.authority()
	if cmd then
		local func = nil
		local fail_auth = nil
		for auth,cmd in pairs(CMD) do
			if auth <= authority then
				local cmds = CMD[auth]
				if cmds[cmd] then
					func = cmds[cmd]
					break
				end
			else
				local cmds = CMD[auth]
				if cmds[cmd] then
					func = cmds[cmd]
					fail_auth = string.format("authority fail(%d < %d)",authority,auth)
				end
			end
		end
		assert(fail_auth == nil,fail_auth)
		master = player
		if not func then
			if authority >= gm.AUTH_ADMIN then
				func = load(cmdline)
				func()
			else
				error("unknow cmd:" .. tostring(cmd))
			end
		else
			local args = {}
			if cmdline then
				for arg in string.gmatch(cmdline,"[^%s]+") do
					table.insert(args,arg)
				end
			end
			func(args)
		end
		master = nil
		return "success"
	else
		error("cann't parse cmdline:" .. tostring(cmdline))
	end
end

function gm.docmd(player,cmdline)
	local ok,result = pcall(__docmd,player,cmdline)
	logger.log("info","gm",string.format("#%d(authority=%s) docmd %s result=%s tips=%s",player.id,player.authority(),cmdline,ok,result))
	net.msg.notify(player,string.format("执行%s",ok and "成功" or "失败"))
end

local AUTHORITY = {
}

--- usage: setauthority pid authority
--- e.g. : setauthority 10001 80 # 将玩家10001权限设置成80(权限范围:[1,100])
function AUTHORITY.setauthority(args)
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
	if master.id == player.id then
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
	if target_auth == gm.AUTH_SUPERADMIN then
		net.msg.notify(master,"警告:你无法对超级管理员设定权限")
		return
	end
	if authority == gm.AUTH_SUPERADMIN then
		net.msg.notify(master,"警告:你无法将他人设置成超级管理员")
		return
	end
	logger.log("info","authority",string.format("#%d(authority=%d) setauthority,pid=%d authority(%d->%d)",auth,pid,target_auth,authority))
	player:setauthority(authority)
end



function gm.init()
	gm.AUTH_SUPERADMIN = 100
	gm.AUTH_ADMIN = 90
	gm.AUTH_PROGRAMER = 80
	gm.AUTH_DESIGNER = 70
	gm.AUTH_NORMAL = 10
end

gm.init()

local CMD = {
	[gm.AUTH_SUPERADMIN] = {
	},
	[gm.AUTH_ADMIN] = {
	},
	[gm.AUTH_PROGRAMER] = {
	},
	[gm.AUTH_DESIGNER] = {
	},
	[gm.AUTH_NORMAL] = {
		setauthority = AUTHORITY.setauthority,
		buildgmdoc = helper.buildgmdoc, 
	},
}

gm.CMD = CMD

return gm
