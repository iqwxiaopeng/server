local skynet = require "skynet"
local logger = require "script.base.logger"
timer = {}
function timer.timeout(flag,ti,func)
	logger.log("debug",string.format("timeout,flag=%s ti=%s func=%s",flag,ti,func))
	skynet.timeout(ti,func)
end

function timer.untimeout(flag)
	logger.log("debug",string.format("untimeout,flag=%s",flag))
end
return timer
