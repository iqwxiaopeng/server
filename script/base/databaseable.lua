require "gamelogic.base.class"
require "gamelogic.base.netcache"

begin_declare("databaseable",databaseable)
databaseable = class()
local sep = "."

databaseable.new = nil

function databaseable:init(conf)
	self.id = conf.id
	self.__flag = conf.flag
	assert(self.id,"no id")
	assert(self.__flag,"no flag")
	self.dirty = false
end

function databaseable:clear()
	self.dirty = false
	self.data = {}
end

function databaseable:update(action,key,oldval,newval)
	print(action,key,oldval,newval,self.id,"gg")
	if oldval ~= newval then
		self.dirty = true
		if self.id > 0 then
			netcache.update(self.id,self.__flag,key,newval)
		end
	end
end

function databaseable:basic_set(key,val)
	local oldval = self.data[key]
	self.data[key] = val
	self:update("set",key,oldval,val)
	return oldval
end

function databaseable:basic_query(key,default)
	return self.data[key] or default
end

function databaseable:basic_delete(key)
	local oldval = self.data[key]
	self.data[key] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

function databaseable:basic_add(key,val)
	local oldval = self.data[key]
	self.data[key] = (self.data[key] or 0) + val
	self:update("add",key,oldval,self.data[key])
	return oldval
end

function databaseable:last_key_mod(data,key)
	local lastmod = data
	local lastkey
	local start = 1
	local b,e = string.find(key,sep,start,true)
	while b do
		--print(b,e,start)
		lastkey = string.sub(key,start,b-1)
		assert(string.len(string.gsub(lastkey,"[ \t\n]","")) ~= 0,"occur white string")
		if lastmod[lastkey] then
			if type(lastmod[lastkey]) ~= "table" then
				return nil
			end
			lastmod = lastmod[lastkey]
		else
			lastmod[lastkey] = {}
			lastmod = lastmod[lastkey]
		end
		start = e + 1
		b,e = string.find(key,sep,start,true)
	end
	lastkey = string.sub(key,start)
	assert(string.len(string.gsub(lastkey,"[ \t\n]","")) ~= 0,"occur white string")
	return true,lastkey,lastmod
end

function databaseable:set(key,val)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)	
	if not ok then
		error(string.format("[databaseable:set] exists same variable, pid=%d key=%s",self.id,key))
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = val
	self:update("set",key,oldval,val)
	return oldval
end

function databaseable:query(key,default)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		return default
	end
	return lastmod[lastkey] or default
end

databaseable.get = databaseable.query

function databaseable:delete(key)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		return nil
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

function databaseable:add(key,val)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		error(string.format("[databaseable:add] exists same variable, pid=%d key=%s",self.id,key))
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = (lastmod[lastkey] or 0) + val
	self:update("add",key,oldval,lastmod[lastkey])
	return oldval
end
end_declare("databaseable",databaseable)

return databaseable
