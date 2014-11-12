破碎残阳祭祀: warcry = {
	sel_friendly_footman = {
		{addhp = 1,addatk = 1,},
	}
}

郎骑兵: warcry = {
	self = {
		{assault = 100},
	}
}

巫医: 
warcry = {
	self_hero = {
		{addhp = 2,},
	}
}

石牙野猪:
warcry = {
	self = {
		{assault = 100,}
	}
}

森金持盾卫士:
aliveeffect = {
	self = {
		{sneer = 100,}
	}
}

鲁莽火箭兵: 
warcry = {
	self = {
		{assault = 100,}
	}
}

团队领袖:
aliveeffect = {
	all_friendly_footman = {
		{addatk = 1,}
	}
}

工程师学徒:
warcry = {
	self_hero = {
		{pickcard = 1,}
	}
}

夜刃刺客:
warcry = {
	enemy_hero = {
		{addhp = -3,}
	}
}

年轻的酒仙:
warcry = {
	sel_friendly_footman = {
		{recycle = true,}
	}
}

幼龙鹰:
aliveeffect = {
	self = {
		{double_attack = 100,},
	}
}

狼人渗透者:
aliveeffect = {
	self = {
		{sneek = 100,}
	}
}

风险投资公司雇佣兵:
aliveeffect = {
	all_friendly_hand_footman = {
		{addcrystalcost = 3,}
	}
}


牛头人战士
aliveeffect = {
	self = {
		{sneer = 100,enrage = 3,}
	}
}

南海船工

warcry = {
	self_hero = {
		on_equip_weapon = {
			self = {assault = 1,}
		}
	}
}

aliveeffect = {
	self_hero = {
		on_equip_weapon = {
			self = {assault = 1,}
		}
	}
}

暴风城勇士:
aliveeffect = {
	all_friendly_footman = {
		{addhp = 1,addatk = 1},
	}
}

dieeffect = {
	all_friendly_footman = {
		{removebuf = true,}
	}
}

白银只手骑士:
warcry = {
	self_hero = {
		{addfootman = xxx,}
	}
}

阿曼尼狂战士:
aliveeffect = {
	self = {
		{onsneer = {
			self = {addatk = 3,},
		}}
	}
}


苦痛侍僧:
aliveeffect = {
	self = {
		onhurt = {
			self_hero = {pickcard = 1,}
		},
	}
}



抽牌者:
aliveeffect = {
	other_friendly_footman = {
		{
			ondie = {
				self_hero = {pickcard = 1,}
			}
		}
	}
}

秃鹫:
aliveeffect = {
	self_hero = {
		on_add_animal_footman = {
			self_hero = {pickcard = 1,}	
		}
	}
}

多重射击:
warcry = {
	any_two_enemy_footman = {
		{addhp = -3,}
	}
}

爆炸射击:
warcry = {
	sel_enemy_footman = {
		{addhp = -5,}
	}
	left_enemy_footman = {
		{addhp = -2,}
	}
	right_enemy_footman = {
		{addhp = -2,}
	}
}

牛头人战士
aliveeffect = {
	self = {
		{sneer = 100,enrage = 3,}
	}
}

南海船工

warcry = {
	self_hero = {
		on_equip_weapon = {
			self = {assault = 1,}
		}
	}
}

aliveeffect = {
	self_hero = {
		on_equip_weapon = {
			self = {assault = 1,}
		}
	}
}

暴风城勇士:
aliveeffect = {
	self = {
		all_footman = {
			{addbuf = {addhp = 1,addatk = 1,}}
		}
	}
}


白银只手骑士:
warcry = {
	self_hero = {
		{addfootman = xxx,}
	}
}

阿曼尼狂战士:
aliveeffect = {
	self = {
		{onsneer = {
			self = {addatk = 3,},
		}}
	}
}


苦痛侍僧:
aliveeffect = {
	self = {
		{onhurt = {
			self_hero = {pickcard = 1,}
		}},
	}
}

抽牌者:
ondie = {
	self_other_friendly_footman = {
		{self_hero = {pickcard = 1,}
	}
}

秃鹫:
aliveeffect = {
	self_hero = {
		on_add_animal_footman = {
			self_hero = {pickcard = 1,}	
		}
	}
}

多重射击:
warcry = {
	any_two_enemy_footman = {
		{addhp = -3,}
	}
}

爆炸射击:
warcry = {
	sel_enemy_footman = {
		{addhp = -5,}
	}
	left_enemy_footman = {
		{addhp = -2,}
	}
	right_enemy_footman = {
		{addhp = -2,}
	}
}

warcry = {
	self = {
		all_footman = {
			{addhp = 3,addatk = 3,}
		}
	},
	enemy = {
		all_footman = {
			{setatk = 1,},
		}
	}
}

aliveeffect = {
	self = {
		footman = {
			{addbuf = {addhp = 1,addatk = 1,}},
			{addhp = 1,addatk = 1},
			onhurt = {
				{addatk = 3,},
				cardself = {
					freeze = {addatk = 3,},
					{addhp = 3,},
				},
				enemy = {
					footman = {
						{addatk = 3,}
					}
				},
				fish_footman = {
					{addhp = 3,}
				},
			},
			ondie = {
				hero = {
					{pickcard = 1,},
				},
			},
			ondefense = {
				hero = {
					{addatk = 3,},
				}
			},
			onattack = {
				hero = {
					{addhp = -3,},
				},
			}
		},
		hero = {
			onhurt = {
				cardself = {addatk = 1,},
			},
			ondefense = {
				{addatk = 3,}
			},
			onattack = {
				{addhp = -3,}
			},
		}
	},
	enemy = {
		footman = {
			onhurt = {
				cardself = {addatk = 1,},
			}
		}
	}
}

onbeginround = {
	self = {
		cardself = {addhp = 3,addatk = 3,}
	},
	enemy = {
		footman = {
			{addhp = -3}
		}
	},
}

onendround = {
	self = {
		footman = {addhp = -3,}
	},
	enemy = {
		footman = {addhp = 3,}
	},
}

ondie = {
	self = {
		{addfootman = xxx,}
	},
	enemy = {
		{recycle = "any",}
	}
}
