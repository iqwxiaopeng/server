-- [500,600)
local proto = {}
proto.c2s = [[
war_selectcardtable 500 {
	request {
		cardtableid 0 : integer
	}
}

war_searchplayer 501 {
	response {

	}
}

war_confirm_handcard 502 {
	request {
		# 战斗卡牌SID列表
		cardsids 0 : *integer
	}
}

war_playahand 503 {
	request {
		cardid 0 : integer
		targetid 1 : integer
	}
}

war_endround 504 {
}
]]

proto.s2c = [[

.weapon {
	atk 0 : integer
	validcnt 1 : integer
}

.state {
	freeze 0 : integer
	sneer 1 : integer
}

.buf {
	addhp 0 : integer
	addatk 1 : integer
	addcrystal 2 : integer
	sethp 3 : integer
	setatk 4 : integer
	setcrystal 5 : integer
}

.carddata {
	cardid 0 : integer
	sid 1 : integer
	hp 2 : integer
	atk 3 : integer
	state 4 : .state
	buf 5 : .buf
}


.hero {
	hp 0 : integer
	atk 1 : integer
	crystal 2 : integer
	empty_crystal 3 : integer
	weapon 4 : .weapon
	state 5 : .state
}

war_startwar 500 {
	request {
		# 0--attacker; 1--defenser
		type 0 : integer
	}
}

war_refreshwar 501 {
	request {
		self 0 : .hero
		enemy 1 : .hero
		carddatas 2 : *.carddata
	}
}

war_warresult 502 {
	request {
		win 0 : boolean
	}
}
war_startround 503 {
	request {
		round 0 : integer
	}
}

war_random_handcard 504 {
	request {
		cardsids 0 : *integer
	}
}

war_matchplayer 505 {
	request {
		pid 0 : integer
		race 1 : integer
		name 2 : string
		lv 3 : integer
		photo 3 : integer
		# 显示的成就列表
		ap 4 : *integer
		isattacker 5 : boolean
	}
}
]]

return proto
