寒冰箭: warcry = {
	seltarget = {
		{addhp = -3,freeze = 1},
	}
}

奥术飞弹: warcry = {
	all_enemy_footman = {
		{hurt_random_alloc = 3,}
	}
}

暴风雪: warcry = {
	all_enemy_footman = {
		{addhp = -2,freeze = 1},
	}
}

烈焰风暴: warcry = {
	all_enemy_footman = {
		{addhp = -4,}
	}
}

变形术: warcry = {
	self_heroootman = {
		{changeto = xxx,}
	},
}

火球术: warcry = {
	seltarget = {
		{addhp = -6,},
	},
}

奥术智慧: warcry = {
	self_hero = {
		{pickcard = 2,},
	}
}

魔爆术: warcry = {
	all_enemy_footman = {
		{addhp = -1,},
	}
}

冰霜新星: warcry = {
	all_enemy_footman = {
		{freeze = 1,},
	}
}

冰锥术: warcry = {
	sel_enemy_footman = {
		{addhp = -1,freeze = 1,},
	},
	left_enemy_footman = {
		{addhp = -1,freeze = 1,},
	},
	right_enemy_footman = {
		{addhp = -1,freeze = 1,},
	},
}

蒸发: warcry = {
	self_hero = {
		{add_secret = xxx,},
	}
}

肯瑞托法师: warcry = {
	self_all_hand_secret_card = {addbuf = {setcrystalcost = 0}}
}

on_use_card = {
	self_all_hand_secret_card = {delbuf = {"setcrystalcost"}}
}

法术反制: warcry = {
	self_hero = {
		{add_secret = xxx,},
	}
}

镜像: warcry = {
	self_hero = {
		{addfootman = xxx,},
		{addfootman = xxx,},
	}
}

镜像实体: warcry = {
	self_hero = {
		{add_secret = xxx,},
	}
}

冰枪术: warcry = {
	seltarget = {
		freeze = {addhp = -4,}
		not_freeze = {setstate={freeze=true,}}	
	}
}

寒冰护体: warcry = {
	self_hero = {
		{add_secret = xxx,}
	}
}

扰咒术: warcry = {
	self_hero = {
		{add_secret = xxx,}
	}
}

炎爆术: warcry = {
	seltarget = {
		{addhp = -10,}
	}
}

寒冰屏障: warcry = {
	self_hero = {
		{add_secret = xxx,}
	}
}

	
