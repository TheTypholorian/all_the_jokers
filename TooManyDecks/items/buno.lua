-- -------------------------------------BUNO!!!!-------------------------------------

SMODS.Atlas {
	key = "hcbunocards",
	px = 71,
	py = 95,
	path = "buno2.png"
}

SMODS.Atlas {
	key = "bunocards",
	px = 71,
	py = 95,
	path = "buno1.png"
}

SMODS.Atlas {
	key = "bunoui",
	path = "bunoui1.png",
	px = 18,
	py = 18
}

SMODS.Atlas {
	key = "bunouihc",
	path = "bunoui2.png",
	px = 18,
	py = 18
}

SMODS.Suit {
	key = "BSpades",
	card_key = "BSpades",
	pos = {y=3},
	ui_pos = {x=3,y=0},
	loc_txt = {singular = "Spade", plural = "Spades"},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	lc_ui_atlas = "bunoui",
	hc_ui_atlas = "bunouihc",
	lc_colour = HEX("3c4368"),
	hc_colour = HEX("0171bb"),
	in_pool = function (self, args)
		return false
	end
}

SMODS.Suit {
	key = "BHearts",
	card_key = "BHearts",
	pos = {y=0},
	ui_pos = {x=0,y=0},
	loc_txt = {singular = "Heart", plural = "Hearts"},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	lc_ui_atlas = "bunoui",
	hc_ui_atlas = "bunouihc",
	lc_colour = HEX("f03464"),
	hc_colour = HEX("ed1b24"),
	in_pool = function (self, args)
		return false
	end
}

SMODS.Suit {
	key = "BClubs",
	card_key = "BClubs",
	pos = {y=1},
	ui_pos = {x=2,y=0},
	loc_txt = {singular = "Club", plural = "Clubs"},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	lc_ui_atlas = "bunoui",
	hc_ui_atlas = "bunouihc",
	lc_colour = HEX("235955"),
	hc_colour = HEX("51a744"),
	in_pool = function (self, args)
		return false
	end
}

SMODS.Suit {
	key = "BDiamonds",
	card_key = "BDiamonds",
	pos = {y=2},
	ui_pos = {x=1,y=0},
	loc_txt = {singular = "Diamond", plural = "Diamonds"},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	lc_ui_atlas = "bunoui",
	hc_ui_atlas = "bunouihc",
	lc_colour = HEX("f06b3f"),
	hc_colour = HEX("e0ce00"),
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B10",
	card_key = "B10",
	pos = {x=8},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Zero"},
	shorthand = "0",
	face_nominal = 0,
	nominal = 1,
	next = {"SGTMD_BAce"},
	
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BAce",
	card_key = "BAce",
	pos = {x=12},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "One"},
	shorthand = "1",
	face_nominal = 0,
	nominal = 1,
	next = {"2"},
	
	in_pool = function (self, args)
		return false
	end
}


SMODS.Rank {
	key = "BJack",
	card_key = "BJack",
	pos = {x=9},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Skip"},
	shorthand = "S",
	nominal = 10,
	face_nominal = 0,
	next = {"SGTMD_BQueen"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BQueen",
	card_key = "BQueen",
	pos = {x=10},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Reverse"},
	shorthand = "R",
	nominal = 10,
	face_nominal = 0.5,
	next = {"SGTMD_BKing"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BKing",
	card_key = "BKing",
	pos = {x=11},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "+2"},
	shorthand = "+2",
	nominal = 10,
	face_nominal = 1,
	next = {"SGTMD_BJack"},
	in_pool = function (self, args)
		return false
	end
}



--- BUNO END!!!!!!!
