-- [500,600)
local proto = {}
proto.c2s = [[
war_selectcardtable 500 {
	request {
		id 0 : integer
	}
}

war_searchplayer 501 {
}

war_confirm_startinghand 502 {
	request {
		# 战斗卡牌ID列表
		cardids 0 : *integer
	}
	response {
		# 0--startwar
		result 0 : integer
	}
}

.carddatatype {
	cardid 0 : integer
	hp 1 : integer
	hurt 2 : integer
}

war_playahand 503 {
	request {
		cardid 0 : integer
	}
	response {
		carddatas 0 : *carddatatype
	}
}
]]

proto.s2c = [[
]]

return proto
