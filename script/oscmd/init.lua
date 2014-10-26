require "script.base"
require "script.hotfix"
require "script.logger"

oscmd = oscmd or {}
local delay = 60
local filename = "../shell/.oscmd.txt"

function oscmd.init()
	logger.log("info","oscmd","init")
	timer.timeout("timer.oscmd",delay,oscmd.ontimer)
end

function oscmd.ontimer()
	timer.timeout("timer.oscmd",delay,oscmd.ontimer)
	local fd = io.open(filename,"rb")
	if not fd then
		return
	end
	for line in fd:lines() do
		oscmd.docmd(line)
	end
	fd:close()
	os.execute("rm -rf " .. filename)
end

function oscmd.docmd(line)
	logger.log("info","oscmd","docmd: " .. line)
	local cmd,leftcmd = string.match(line,"^([%w_]+)%s+(.*)$")
	local args = {}	
	for arg in string.gmatch(leftcmd,"([^%s]+)") do
		table.insert(args,arg)
	end
	if cmd == "hotfix" then
		hotfix.hotfix(leftcmd)
	end
end

return oscmd
