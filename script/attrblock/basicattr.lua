require "gamelogic.base"

print("cbasicattr",databaseable)
begin_declare("cbasicattr",cbasicattr)
cbasicattr = class(databaseable)
function cbasicattr:init(conf)
	databaseable.init(self,conf)
	self.data = {}
end

function cbasicattr:save()
	return self.data
end

function cbasicattr:load(data)
	if not data then
		return
	end
	self.data = data
end

function cbasicattr:clear()
	databaseable.clear(self)
end
end_declare("cbasicattr",cbasicattr)
