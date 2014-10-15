require "script.base"

local SAVE_DELAY = 5 --300
__saveobjs = __saveobjs or setmetatable({},{__mode="kv",})
__id = __id or 0

local function add_saveobj(obj)
	__id = __id + 1
	assert(__saveobjs[__id] == nil,"repeat saveobj id:" .. tostring(__id))
	__saveobjs[__id] = obj
	obj.__id = __id
	logger.log("info","saveobj",string.format("add_saveobj %s",obj:uniqueflag()))
end

local function del_saveobj(obj)
	logger.log("info","saveobj",string.format(" del_saveobj %s",obj:uniqueflag()))
	local id = obj.__id
	__saveobjs[id] = nil
	obj:nowsave()
end

local function get_saveobj(id)
	return __saveobjs[id]
end

local function onerror(err)
	msg = string.format("sknerror [ERROR] %s %s\n",os.date("%Y-%m-%d %H:%M:%S"),err)
		.. debug.traceback()
	logger.log("saveobj",msg)
	skynet.error(msg)
end

local function ontimer(id)
	local obj = get_saveobj(id)
	--printf("saveobjs:%s",keys(__saveobjs))
	if obj then
		local flag = obj:uniqueflag()
		logger.log("info","saveobj",string.format("%s ontimer",flag))
		timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__id))
		obj:nowsave()
	end
end

local function starttimer(obj)
	local flag = obj:uniqueflag()
	logger.log("info","saveobj",string.format("%s starttimer",flag))
	timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__id))
end


csaveobj = class("csaveobj")
function csaveobj:init(conf)
	self.__flag = conf.flag
	add_saveobj(self)
	self.id = conf.id
	self.mergelist = setmetatable({},{__mode = "kv"})
	self.saveflag = false
	local meta = getmetatable(self) or {}
	meta.__gc = del_saveobj
	setmetatable(self,meta)
	starttimer(self)
end

function csaveobj:autosave()
	assert(self.saveflag ~= "oncesave","autosave conflict with oncesave")
	logger.log("info","saveobj",string.format(" %s autosave",self:uniqueflag()))
	self.saveflag = "autosave"	
end

function csaveobj:merge(obj)
	local id = obj.__id
	assert(type(id) == "number","saveobj invalid id type:" .. tostring(type(id)))
	logger.log("info","saveobj",string.format("%s merge %s",self:uniqueflag(),obj:uniqueflag()))
	self.mergelist[id] = obj
end

function csaveobj:oncesave()
	assert(self.saveflag ~= "autosave","oncesave conflict with autosave")
	logger.log("info","saveobj",string.format("%s oncesave",self:uniqueflag()))
	self.saveflag = "oncesave"
end

function csaveobj:savetodatabase()
	logger.log("info","saveobj",string.format("%s savetodatabase",self:uniqueflag()))
--	if not self.loadstate ~= "loaded" then
--		return
--	end
end

function csaveobj:loadfromdatabase()
	logger("info","saveobj",string.format("%s loadfromdatabase",self:uniqueflag()))
--	if self.loadstate == "unload" then
--		self.loadstate = "loading"
--		-- XXX
--		self.loadstate = "loaded"
--	end
end

function csaveobj:nowsave()
	if self.saveflag == "oncesave" or self.saveflag == "autosave" then
		pcall(function ()
			self:savedatabase()
			logger.log("info","saveobj",string.format("%s mergelist: %s",self:uniqueflag(),isempty(self.mergelist)))
			for id,mergeobj in pairs(self.mergelist) do
				self.mergelist[id] = nil
				if mergeobj.mergelist[self.__id] then
					mergeobj.mergelist[self.__id] = nil
				end
				mergeobj:nowsave()
			end
		end,onerror)
	end
	if self.saveflag == "oncesave" then
		self.saveflag = false
	end
end

function csaveobj:clearsaveflag()
	logger.log("info","saveobj",string.format("%s clearsaveflag",self:uniqueflag()))
	self.saveflag = false
end

function csaveobj:uniqueflag()
	return string.format("%s.%s",self.__flag,self.__id)
end


