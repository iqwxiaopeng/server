require "script.base"

--- 1. player ready
--- 2. startwar
--- 3. loopround
--- 4. endwar


cwar = class("cwar",cdatabaseable)

function cwar:init()
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
end

function cwar:startwar()
	self:loopround()
end

function cwar:endwar()
end

function cwar:loopround()

end

function cwar:beginround()
end

function cwar:endround()
end

return cwar
