local skynet = require "skynet"
require "script.logger"

local patten = skynet.getenv("script")
local ignore_module = {
	script.agent = true,
	script.watchdog = true,
}

function reload(modname)
	if not package.loaded[modname] then
		logger.log("info","reload",string.format("unload module:%s,not need to reload",modname))
		return
	end
	if modname:sub(1,6) ~= "script" then
		logger.log("warning","reload",string.format("cann't reload non-script code,module=%s",modname))
		return
	end
	if ignore_module[modname] then
		return
	end
	local chunk,err
	local errlist = {}
	local name = string.gsub(modname,"%.","/")
	for pat in string.gmatch(patten,"[^;]+") do
		local filename = string.gsub(pat,"?",name)
		chunk,err = loadfile(filename)
		if chunk then
			break
		else
			table.insert(errlist,err)
		end
	end
	if not chunk then
		local msg = string.format("reload fail,module=%s reason=%s",modname,table.concat(errlist,"\n"))
		logger.log("error","reload",msg)
		skynet.error(msg)
		return
	end
	package.loaded[modname] = chunk()
	logger.log("info","reload","reload " .. modname)
end


