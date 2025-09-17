local Mod = SMODS.current_mod

function Mod:debugMessage(message)
	sendDebugMessage('[Telepurte Cards] ' .. message)
end

Mod:debugMessage("Launching")

--icon--
SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32
})

--clubs--
SMODS.Atlas{
    key = "telepurte_clubs_1",
    path = "telepurte_clubs_1.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.Atlas{
    key = "telepurte_clubs_2",
    path = "telepurte_clubs_2.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.DeckSkin{
	key = "telepurte_clubs",
	suit = 'Clubs',
	palettes = {
		{
			key = 'lc',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_clubs_1',
			posStyle = 'suit'
		},
		{
			key = 'Hunatro',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_clubs_2',
			posStyle = 'suit',
			colour = HEX('87b445')
		}
	},
	loc_txt = {
		['en-us'] = 'Telepurte'
	}
}

--spades--
SMODS.Atlas{
    key = "telepurte_spades_1",
    path = "telepurte_spades_1.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.Atlas{
    key = "telepurte_spades_2",
    path = "telepurte_spades_2.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.DeckSkin{
	key = "telepurte_spades",
	suit = 'Spades',
	palettes = {
		{
			key = 'lc',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_spades_1',
			posStyle = 'suit'
		},
		{
			key = 'Hunatro',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_spades_2',
			posStyle = 'suit',
			colour = HEX("489cd7")
		}
	},
	loc_txt = {
		['en-us'] = 'Telepurte'
	}
}

--hearts--
SMODS.Atlas{
    key = "telepurte_hearts_1",
    path = "telepurte_hearts_1.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.Atlas{
    key = "telepurte_hearts_2",
    path = "telepurte_hearts_2.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.DeckSkin{
	key = "telepurte_hearts",
	suit = 'Hearts',
	palettes = {
		{
			key = 'lc',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_hearts_1',
			posStyle = 'suit'
		},
		{
			key = 'Hunatro',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_hearts_2',
			posStyle = 'suit',
			colour = HEX('e24b3b')
		}
	},
	loc_txt = {
		['en-us'] = 'Telepurte'
	}
}

--Diamonds--
SMODS.Atlas{
    key = "telepurte_diamonds_1",
    path = "telepurte_diamonds_1.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.Atlas{
    key = "telepurte_diamonds_2",
    path = "telepurte_diamonds_2.png",
    px = 71,
    py = 95,
	atlas_table = 'ASSET_ATLAS',
	prefix_config = { key = false }
}

SMODS.DeckSkin{
	key = "telepurte_diamonds",
	suit = 'Diamonds',
	palettes = {
		{
			key = 'lc',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_diamonds_1',
			posStyle = 'suit'
		},
		{
			key = 'Hunatro',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"},
			display_ranks = {'King', 'Queen', 'Jack'},
			atlas = 'telepurte_diamonds_2',
			posStyle = 'suit',
			colour = HEX('e1893d')
		}
	},
	loc_txt = {
		['en-us'] = 'Telepurte'
	}
}

if TexturePack and AltTexture then

	Mod:debugMessage("Installing Malverk texture pack")

	AltTexture({
		key = 'telepurteJokers',
		set = 'Joker',
		path = 'Jokers.png',
		loc_txt = {
		  name = 'Telepurte Cards',
		},
		display_pos = {x=2,y=0},
		original_sheet = false,
		keys = {
			"j_rough_gem",
			"j_bloodstone",
			"j_arrowhead",
			"j_onyx_agate",
		},
	})

	TexturePack({
		key = "telepurteJokers",
		textures = {
			"telepurteCards_telepurteJokers"
		},
		localization = true
	})
	
else
	Mod:debugMessage("Loading textures directly into atlases")

	--jokers--
	SMODS.Atlas{
		key = 'telepurte_jokers',
		path = 'Jokers.png',
		px = 71,
		py = 95,
		atlas_table = 'ASSET_ATLAS'
	}

	SMODS.Joker:take_ownership('j_rough_gem', {
		atlas = "telepurte_jokers",
		pos = { x = 0, y = 0 },
		loc_txt = {
			['en-us'] = {
				name = 'Amina',
				text = {
					"Played cards with",
					"{C:diamonds}Diamonds{} suit earn",
					"{C:money}$#1#{} when scored", 
				},
				unlock = {
					"Have at least {E:1,C:attention}#1#",
					"cards with {E:1,C:attention}#2#",
					"suit in your deck"
				}
			}
		}
	})

	SMODS.Joker:take_ownership('j_bloodstone', {
		atlas = "telepurte_jokers",
		pos = { x = 1, y = 0 },
		loc_txt = {
			['en-us'] = {
				name = 'Chloe',
				text = {
					"{C:green}#1# in #2#{} chance for",
					"played cards with",
					"{C:hearts}Hearts{} suit to give",
					"{X:mult,C:white} X#3# {} Mult when scored", 
				},
				unlock = {
					"Have at least {E:1,C:attention}#1#",
					"cards with {E:1,C:attention}#2#",
					"suit in your deck"
				}
			}
		}
	})

	SMODS.Joker:take_ownership('j_arrowhead', {
		atlas = "telepurte_jokers",
		pos = { x = 2, y = 0 },
		loc_txt = {
			['en-us'] = {
				name = 'Nila',
				text = {
					"Played cards with",
					"{C:spades}Spades{} suit give",
					"{C:chips}+#1#{} Chips when scored",
				},
				unlock = {
					"Have at least {E:1,C:attention}#1#",
					"cards with {E:1,C:attention}#2#",
					"suit in your deck"
				}
			}
		}
	})

	SMODS.Joker:take_ownership('j_onyx_agate', {
		atlas = "telepurte_jokers",
		pos = { x = 3, y = 0 },
		loc_txt = {
			['en-us'] = {
				name = 'Zoe',
				text = {
					"Played cards with",
					"{C:clubs}Club{} suit give",
					"{C:mult}+#1#{} Passion when scored", 
				},
				unlock = {
					"Have at least {E:1,C:attention}#1#",
					"cards with {E:1,C:attention}#2#",
					"suit in your deck"
				}
			}
		}
	})
end

-------------------
--- Credits Tab ---
-------------------
Mod.credits_tab = function()

	local title_scale = 0.9 * 0.6
	local text_scale = 0.9 * 0.5
	
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Programming', scale = title_scale, colour = G.C.GOLD, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'OneSuchKeeper', scale = text_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					}
				}
			},
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Art', scale = title_scale, colour = G.C.RED, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Telepurte', scale = text_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'OneSuchKeeper', scale = text_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
				}
			}
		}
	}
end

----------------------------------------------
------------MOD CODE END----------------------