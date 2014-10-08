----------------------------------------------------------
--功能: 给lua oop提供原语class
--用例: 参考测试脚本:test_class.lua
--参考: blog.codingnow.com/cloud/LuaOO
----------------------------------------------------------
__class = __class or {}
function reload__class(name)
	assert(__class[name] ~= nil,"try to reload a empty class")
	local class_type = __class[name]
	for k,v in pairs(class_type) do
		class_type[k] = nil
	end
	local vtb = __class[class_type]
	assert(vtb ~= nil,"class without vtb")
	for k,v in pairs(vtb) do
		vtb[k] = nil
	end
	print(string.format("reload class,name=%s addr=%#X vtb_addr=%#X",name,class_type,vtb))
	return class_type
end

function class(name,...)
	local super = {...}
	local class_type
	if not __class[name] then
		class_type = {}
	else
		class_type = reload__class(name)
	end
	class_type.__name__ = name
	class_type.init = false		--constructor
	class_type.super = super
	class_type.new = function (...)
		local tmp = ...
		assert(tmp ~= class_type,"must use class_type.new(...) but not class_type:new(...)")
		local obj = {}
		obj.__type__ = class_type
		setmetatable(obj,{__index = __class[class_type]});
		do
			--function create(class_type,...)
			--	for _,super_type in pairs(class_type.super) do
			--		create(super_type,...)
			--	end
			--	if class_type.init then
			--		class_type.init(obj,...)
			--	end
			--end
			--create(class_type,...)
			if class_type.init then
				class_type.init(obj,...)
			end
		end
		return obj
	end
	if not __class[name] then -- if not getmetatable(class_type) then
		local vtb = {}
		__class[name] = class_type
		__class[class_type] = vtb
		setmetatable(class_type,{__index = vtb,__newindex =
			function (t,k,v)
				vtb[k] = v
			end
		})
		setmetatable(vtb,{__index =
			function (t,k)
				for _,super_type in pairs(class_type.super) do
					if __class[super_type][k] then
						--print("vtb.__index",super_type,k)
						vtb[k] = __class[super_type][k]
						return __class[super_type][k]
					end
				end
			end
		})
	end
	return class_type
end

