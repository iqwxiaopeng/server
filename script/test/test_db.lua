local skynet = require "skynet"
local db = require "script.db"
require "script.base"

function test()
	tblname = "test"
	db.init()
	print(db.query(tblname .. ":key1"))
	print(db.set(tblname .. ":key1",1))
	print(db.query(tblname .. ":key1"))
	print(db.delete(tblname .. ":key1"))
	value = {
		test = {
			test1 = {
				test2 = 'ok',
			},
			good = 3,
		},
		hello = 'world',
		[1] = "one",
		[100] = "hundread",
		[1000] = "thousand",
	}
	print(db.set(tblname .. ":tblkey",value))
	pprintf("%s",db.query(tblname .. ":tblkey"))
end

skynet.start(test)
return test

