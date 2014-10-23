local codecache = require "skynet.codecache"

local hotfix = {}


function hotfix.reload(modname)
	print("reload " .. tostring(modname))
	package.loaded[modname] = nil
	codecache.clear()
	require(modname)
end

return hotfix
