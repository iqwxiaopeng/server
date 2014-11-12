require "script.base"

ccategorytarget = class("ccategorytarget")

function ccategorytarget:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.bufs = {}
	self.id_obj = {}
end

function ccategorytarget:addobj(obj)
	local id = obj.warcardid
	assert(self.id_obj[id] == nil,"Repeat warcardid:" .. tostring(id))
	self.id_obj[id] = obj
end

function ccategorytarget:delobj(id)
	self.id_obj[id] = nil
end

function ccategorytarget:addbuf(value,srcid)
	table.insert(self.bufs,{srcid=srcid,value=value,})
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addbuf(value,srcid)
		end
	end
end

function ccategorytarget:delbuf(srcid)
	local delbufs = {}
	for i,v in ipairs(self.bufs) do
		if v.srcid == srcid then
			table.insert(delbufs,i)
		end
	end
	for _,pos in ipairs(delbufs) do
		table.remove(self.bufs,pos)
	end
	if #delbufs > 0 then
		for warcardid,warcard in pairs(self.id_obj) do
			warcard:delbuf(srcid)
		end
	end
end

function ccategorytarget:gethurtorder()
	-- need modify
	return values(self.id_obj)
end

function ccategorytarget:addhp(value,srcid)
	local objs = self:gethurtorder()
	for i,obj in ipairs(objs) do
		obj:addhp(value,srcid)
	end
end

function ccategorytarget:sethp(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:sethp(value,srcid)
	end
end

function ccategorytarget:addatk(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:addatk(value,srcid)
	end
end

function ccategorytarget:setatk(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:setatk(value,srcid)
	end
end

function ccategorytarget:addcrystalcost(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:addcrystalcost(value,srcid)
	end
end

function ccategorytarget:setcrystalcost(value,srcid)
	for id,obj in pairs(self.id_obj) do
		obj:setcrystalcost(value,srcid)
	end
end

return ccategorytarget
