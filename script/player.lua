require "script.base"
require "attrblock.saveobj"

cplayer = class("cplayer",csaveobj,cdatabaseable)

function cplayer:init(id)
	local flag = "cplayer"
	csaveobj.init(self,{
		id = id,
		flag = flag,
	})
	cdatabaseable.init(self,{
		id = id,
		flag = flag,
	})
	self.data = {}
	self:autosave()
end

function cplayer:save()
	local data = {}
	data.data = self.data
end

function cplayer:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function cplayer:savetodatabase()
end

function cplayer:loadfromdatabase()
end

function cplayer:entergame()
end

function cplayer:exitgame()
end

function cplayer:disconnect()
end

function cplayer:onlogin()
end

function cplayer:onlogoff()
end

function cplayer:ondisconnect()
end

function cplayer:ondayupdate()
end

function cplayer:onweekupdate()
end

function cplayer:onweek2update()
end


