local atlas_hc = SMODS.Atlas {
	key = "skin_hc",
	path = "collabs/kh_hc.png",
	px = 71,
	py = 95,
}

local atlas_lc = SMODS.Atlas {
	key = "skin_lc",
	path = "collabs/kh_lc.png",
	px = 71,
	py = 95,
}

SMODS.DeckSkin {
	key = "khhearts",
	suit = "Hearts",
	loc_txt = "Kingom Hearts",
	palettes = {
		{
			key = 'lc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_lc.key,
			pos_style = 'deck',
		},
		{
			key = 'hc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_hc.key,
			pos_style = 'deck',
			colour = HEX("9734f0"),
		},
	},
}

SMODS.DeckSkin {
	key = "khdiamonds",
	suit = "Diamonds",
	loc_txt = "Kingom Hearts",
	palettes = {
		{
			key = 'lc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_lc.key,
			pos_style = 'deck',
		},
		{
			key = 'hc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_hc.key,
			pos_style = 'deck',
			colour = HEX("9734f0"),
		},
	},
}

SMODS.DeckSkin {
	key = "khspades",
	suit = "Spades",
	loc_txt = "Kingom Hearts",
	palettes = {
		{
			key = 'lc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_lc.key,
			pos_style = 'deck',
		},
		{
			key = 'hc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_hc.key,
			pos_style = 'deck',
			colour = HEX("9734f0"),
		},
	},
}

SMODS.DeckSkin {
	key = "khclubs",
	suit = "Clubs",
	loc_txt = "Bryce",
	palettes = {
		{
			key = 'lc',
			ranks = { "King" },
			display_ranks = { "King" },
			atlas = atlas_lc.key,
			pos_style = 'deck',
		},
		{
			key = 'hc',
			ranks = { 'Jack', 'Queen', "King", },
			display_ranks = { "King", "Queen", "Jack" },
			atlas = atlas_hc.key,
			pos_style = 'deck',
			colour = HEX("9734f0"),
		},
	},
}
