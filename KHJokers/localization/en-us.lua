return {
	descriptions = {

		Sleeve = {
			sleeve_kh_kingdom = {
				name = "Kingdom Sleeve",
				text = {
					"{C:legendary}Kingdom Hearts{} {C:attention}Jokers{} are",
					"{C:attention}3X{} more likely to appear",
					"Start run with",
					"{C:attention,T:v_overstock_norm}Overstock{}",

				}
			},

			sleeve_kh_kingdom_alt = {
				name = "Kingdom Sleeve",
				text = {
					"{C:legendary}Kingdom Hearts{} {C:attention}Jokers{} are",
					"{C:attention}3X{} more likely to appear",
					"Start run with {C:attention,T:v_overstock_norm}Overstock{}",
					"and {C:attention,T:v_overstock_plus}Overstock Plus{}",

				}
			}
		},

		Back = {

			b_kh_kingdom = {
				name = "Kingdom Deck",
				text = {
					"Kingdom Hearts Jokers are",
					"{C:attention}3X{} more likely to appear",
					"Start run with the",
					"{C:attention,T:v_overstock_norm}Overstock{} Voucher",
				},
			},
		},
		Joker = {

			j_kh_munnypouch = {
				name = 'Munny Pouch',
				text = {
					"Press {C:green}Withdraw{}",
					"to spawn {C:attention}Munny{}",
					"{C:inactive,s:0.8}Tada! 5000 munny!"
				},
			},

			j_kh_munny = {
				name = 'Munny',
				text = {
					"Earn {C:money}$#1#{} at",
					"end of round",
				},
			},

			j_kh_sora = {
				name = 'Sora',
				text = {
					"This Joker gains {X:mult,C:white}X#2#{} Mult",
					"For each scored {C:hearts}heart{} card, resets",
					"when {C:attention}Boss Blind{} is defeated.{}",
					"{C:inactive}(Currently {X:mult,C:white}X#1# {C:inactive} Mult)",
					"{C:inactive,s:0.8}My Friends are my Power!",
				},
			},

			j_kh_riku = {
				name = 'Riku',
				text = {
					'Levels up most played hand',
					'by #2# every {C:attention}#4#{} {C:green}rerolls',
					'{C:inactive}(Most Played: {C:attention}#1#{}{C:inactive})',
					'{C:inactive}(Reroll {C:attention}#3#{}{C:inactive}/#4#){}',
					--"{C:inactive,s:0.8}I'm not afraid of the darkness!",
					"{C:inactive,s:0.8}I'm thinking RIKU RIKU oo ee oo",
				}

			},

			j_kh_kairi_a = {
				name = 'Kairi',
				text = {
					"{C:chips}+#3#{} Chip per {C:diamonds}Light Suit{} scored",
					"{C:chips}-#4#{} Chip {C:spades}Dark Suit{} scored",
					"{C:inactive,s:0.8}I know you will!",
				}
			},
			j_kh_kairi_b = {
				name = 'Naminé',
				text = {
					"{C:mult}+#3#{} Mult per {C:spades}Dark Suit{} scored",
					"{C:mult}-#4#{} Mult per {C:diamonds}Light Suit{} scored",
					"{C:inactive,s:0.8}It's me, Naminé",

				}
			},

			j_kh_kairi_extra = {
				text = {
					"{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips, {C:mult}+#2#{}{C:inactive} Mult){}",
					'{C:inactive}Joker flips at end of round',

				}
			},

			j_kh_roxas = {
				name = 'Roxas',
				text = {
					"This Joker gains {C:chips}+#1#{} Chips",
					"every {C:attention}#2#{} {C:inactive}[#3#]{} cards discarded",
					"{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)",
					"{C:inactive,s:0.8}looks like my summer vacation is... over",

				},
			},

			j_kh_brycethenobody = {
				name = "BryceTheNobody",
				text = {
					"Every played {C:hearts}Heart{} card",
					"Has a {C:green}#2# in #3#{} chance",
					"to permanently gain",
					"{C:mult}+#1#{} Mult when scored",
					"{C:inactive,s:0.8}Glad i could help some people out"
				},
			},

			j_kh_axel = {
				name = 'Axel',
				text = {
					"{C:enhanced}Doubles{} values of leftmost {C:attention}Joker{}",
					"and applies a {C:spectral}Perishable{} sticker",
					"after defeating a {C:attention}boss blind",
					"{C:inactive,s:0.8}Got it Memorized?",

				},
			},

			j_kh_xigbar = {
				name = "Half Face",
				text = {
					"Gives {C:chips}+#2#{} Chips for each",
					"{C:attention}face{} card in played hand",
					"that {C:attention}does not score{}",
					"{C:inactive,s:0.8}Me? I'm already half Xehanort"
				},
			},

			j_kh_mickey = {
				name = 'Meeska Mooska',
				text = {
					"Every scored {C:attention}King{} has a",
					"{C:green}#1# in #2#{} chance to gain",
					"{C:chips}+#6#{} Chips and {X:mult,C:white}X#4#{} Mult",
					"{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips and {X:mult,C:white}X#3#{C:inactive} Mult )",
					"{C:inactive,s:0.8}Say Fellas, did somebody mention the Door to Darkness?"
				},
			},

			j_kh_donald = {
				name = 'Donald Duck',
				text = {
					"Copies the ability of a",
					"{C:attention}random Joker{} each round.",
					"{C:inactive}(Currently copying: {C:attention}#1#{C:inactive})",
					"{C:inactive,s:0.8}The Snowstorm can't get us here."
				},
			},

			j_kh_goofy = {
				name = "Wild Goofy",
				text = {
					"{C:attention}Wild{} Cards give",
					"random bonuses",
					"when they score:",
					"{s:0.8,X:mult,C:white}X#3#{} {s:0.8}Mult, {s:0.8,C:money}$#4#{}",
					"{s:0.8,C:mult}+#1#{} {s:0.8}Mult, {s:0.8,C:chips}+#2#{} {s:0.8}Chips",
					"{C:inactive,s:0.8}Gawrsh..."
				},
			},

			j_kh_disney = {
				name = 'Master Yen Sid',
				text = {
					"{C:green}#1# in #2#{} chance to",
					"upgrade level of a",
					"random {C:attention}poker hand{} when",
					"a {C:purple}Tarot{} card is used",
					"{C:inactive,s:0.8}Sora, do NOT dissappoint me.",
				},
			},

			j_kh_keyblade = {
				name = 'Keyblade',
				text = {
					"If {C:attention}first hand{} of round is",
					--"a single {C:attention}7{}, destroy it and",
					"a single {C:attention}#1#{}, destroy it and",
					"create a {C:dark_edition}random {}{C:attention}Tag{}",
					"{s:0.8}Rank changes every round",
					"{C:inactive,s:0.8} May your heart be your guiding key",
				},
			},

			j_kh_paopufruit = {
				name = 'Paopu Fruit',
				text = {
					"Retrigger all played {C:diamonds}Diamond{} cards",
					"{C:green}#1# in #2#{} chance this card is",
					"eaten at the end of the round",
					"{C:inactive,s:0.8} the winner gets to share a Paopu with Kairi."
				},
			},

			j_kh_sealsalt = {
				name = "Seal Salt Ice Cream",
				text = {
					"Cards with a {C:blue}Blue Seal{}",
					"trigger when {C:attention}scored",
					"{C:inactive,s:0.8} man, this is some good ice cream, huh?",
				},
			},

			j_kh_nobody = {
				name = 'Nobody',
				text = {
					"Gains {C:chips}+#2#{} Chips per",
					"unique {C:attention}suit{} in played hand",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
					"{C:inactive,s:0.8} Nobody? Who's Nobody?",
				},
			},

			j_kh_moogle = {
				name = 'Moogle',
				text = {
					"Earn {C:money}$#1#{} at end of round",
					"for each {C:attention}Joker{} card",
					"{C:inactive}(Currently {C:money}$#2#{}{C:inactive})",
					"{C:inactive,s:0.8}Greetings"
				},
			},

			j_kh_chipanddale = {
				name = "Chip and Dale",
				text = {
					"{C:attention}Sell{} this card to",
					"create {C:attention}#1#{} {C:uncommon}Uncommon{} Jokers",
					"increases by #4# every {C:attention}#3#{} rounds",
					"{C:inactive}(Currently {C:attention}#2#{C:inactive}/#3#) {C:inactive}(Must Have Room)",
					"{C:inactive,s:0.8}We got baaad news"
				},
			},

			j_kh_luxord = {
				name = 'Luxord',
				text = {
					'Gains {C:chips}+#3#{} Chips for every',
					'{C:attention}second{} passed this round,',
					'{C:red,E:2,s:1.1}self destructs at #2# Chips',
					'Each scored card',
					'increases the cap by {C:green}#4#{}',
					'Each hand increases the',
					'total Chips gained by {C:green}#5#{}',

					--"{C:inactive,s:0.8}I'd rather we just skip the formalities",
				}
			},

			j_kh_khtrilogy_kh1 = {
				name = "Kingdom Hearts 1",
				text = {
					"{C:chips}+#5#{} Chips",
					"Score at least 2x the blind requirements in one",
					"hand to {C:attention}level up{}",
					"{C:inactive}(Next level: {C:mult}+#1#{C:inactive} Mult)",
					"{C:inactive,s:0.8}A true classic",
				}
			},

			j_kh_khtrilogy_kh2 = {
				name = "Kingdom Hearts 2",
				text = {
					"{C:mult}+#1#{} Mult",
					"Play a {C:attention}#6#{}",
					"#4# times to {C:attention}level up{}",
					"{s:0.8}Poker Hand changes every round",
					"{C:inactive}(#3#/#4#, Next level: {X:mult,C:white}X3{C:inactive} Mult)",
					"{C:inactive,s:0.8}peak has arrived",
				}
			},

			j_kh_khtrilogy_kh3 = {
				name = "Kingdom Hearts 3",
				text = {
					"{X:mult,C:white}X#2#{} Mult",
					"{C:inactive,s:0.8}KH4 when???",
				}
			},

			j_kh_helpwanted = {
				name = "Help Wanted!",
				text = {
					"Complete a task to earn a prize!.",
					"New task appears after completion.",
					"{C:red,E:2,s:1}Self Destructs when no tasks remain",
					"{C:attention}Current Task:{} #1#",
					"{C:attention}Current Prize:{} #2#",
					"{C:inactive,s:0.8}Maybe... today we'll finally hit the beach!"
				}
			},

		},


		Other = {

			kh_lightsuit = {
				name = "Light Suit",
				text = {
					"{C:hearts}Hearts{} or {C:diamonds}Diamonds{}",
				}
			},

			kh_darksuit = {
				name = "Dark Suit",
				text = {
					"{C:spades}Spades{} or {C:clubs}Clubs{}",
				}
			},

			kh_unstackable = {
				name = "Unstackable",
				text = {
					"Cannot double a {C:attention}Joker{}",
					"That is {C:enhanced}perishable{}.",
				}
			},

			kh_perishable = {
				name = "Perishable",
				text = {
					"Debuffed after",
					"{C:attention}5{} rounds",
				}
			},

			kh_play_face = {
				name = "Grand Stander",
				text = {
					"Score 15 {C:attention{}Face{} cards",
					"to get {C:attention}+1{} {C:blue}Hand{}"
				}
			},

			kh_destroy_cards = {
				name = "Cargo Climb",
				text = {
					"Destroy 7 cards",
					"to get {C:attention}+1{} {C:red}Discard{}",
				}
			},

			kh_selling = {
				name = "Mail Delivery",
				text = {
					"Sell 13 cards",
					"to get {C:attention}-1{} Ante"
				}
			},
			kh_skipping = {
				name = "Junk Sweep",
				text = {
					"Skip 4 Blinds",
					"to get {C:attention}+1{} Hand Size"
				}
			},

			kh_shopping = {
				name = "Poster Duty",
				text = {
					"Spend {C:money{}${}30 in one shop",
					"to get {C:attention}+1{} Shop Slot"
				}
			},

			kh_munnypouch_credits = {
				name = "Credits",
				text = {
					"{C:attention}PoundOS{} for the idea!"
				}
			},

			kh_munny_info = {
				name = "Munny",
				text = {
					"Earn {C:money}$1{} at",
					"end of round",
				}
			}
		},

		Spectral = {

			c_kh_sorcerer = {
				name = "Sorcerer",
				text = {
					"Select {C:attention}#1#{} card to",
					"apply {C:attention}Lucky Seal{}"
				}
			},

			c_kh_gummiship = {
				name = "Gummi Ship",
				text = {
					"Destroys a random",
					"{C:attention}Joker{} card,",
					"{C:green}+1{} Hand Size"
				},
			},

			c_kh_gummi = {
				name = "Gummi Ship 2",
				text = {
					"Converts all cards",
					"in hand to",
					"random {C:attention}ranks",
					"gain {C:money}$#1#",
				},
			},

		},
		Tarot = {

			c_kh_awakening = {
				name = "Awakening",
				text = {
					"Creates a random",
					"{C:legendary}Kingdom Hearts{} {C:attention}Joker{}",
					"{C:inactive}[Must have room]",
				},
			},

		},
	},

	misc = {
		achievement_descriptions = {},
		achievement_names = {},
		blind_states = {},
		challenge_names = {},
		collabs = {},

		dictionary = {
			k_khjokers_config_jokers = "Enable KH Jokers",
			k_khjokers_config_tarots = "Enable Tarot cards",
			k_khjokers_config_spectrals = "Enable Spectral cards",
			k_khjokers_config_seal = "Enable Seal",
			k_khjokers_config_blind = "Enable Boss Blind",
			k_khjokers_config_restart = "(requires restart)",
			kh_a_side = 'Kairi',
			kh_b_side = 'Naminé',

		},

		high_scores = {},
		labels = {},
		poker_hand_descriptions = {},
		poker_hands = {},
		quips = {},
		ranks = {},
		suits_plural = {},
		suits_singular = {},
		tutorial = {},
		v_dictionary = {},

		v_text = {
			ch_c_kh_got_it_memorized = { "All Blinds are {C:attention}Boss Blinds{}" },
			ch_c_no_skipping = { "Skipping is {C:attention}disabled{}" },
		},
	},
}
