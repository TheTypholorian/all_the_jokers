
SMODS.current_mod.optional_features = {
    -- enable additional SMODS contexts that can be CPU intensive
    retrigger_joker = true,
}

SMODS.Atlas {
    key = "modicon",
    path = "mod_icon.png",
    px = 34,
    py = 34,
}

MXconfig = SMODS.current_mod.config

SMODS.current_mod.config_tab = function() --Config tab
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        create_toggle({
            label = "Experimental Jokers (restart required)",
            ref_table = MXconfig,
            ref_value = "exp",
        }),
      },
    }
end

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas {
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34,
}

	SMODS.Sound {
    key = "europa_hit",
    path = {
        ["default"] = "europa_hit.ogg"
    }
	}
	SMODS.Sound {
    key = "europa_hit1",
    path = {
        ["default"] = "europa_hit1.ogg"
    }
	}
	SMODS.Sound {
    key = "europa_trigger",
    path = {
        ["default"] = "europa_trigger.ogg"
    }
	}
	SMODS.Sound {
    key = "ak47_shoot",
    path = {
        ["default"] = "ak47_shoot.wav"
    },
	volume = 0.6
	}
	SMODS.Sound {
    key = "ak47_boltpull",
    path = {
        ["default"] = "ak47_boltpull.wav"
    }
	}

if true then

SMODS.Joker{ --Novelist
    key = 'novelist', --joker key
    loc_txt = { -- local text
        name = 'Novelist',
        text = {
          '{C:mult}+1{} Mult per {C:attention}two{}',
		  'words in the description',
		  'of each {C:attention}Joker{} card',
		  '{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult)'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		word_count = 7,
		joker_count = 0
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {
		
		center.ability.extra.word_count
		
		}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.jokers then
			card.ability.extra.word_count = 0
            for k, v in pairs(G.jokers.cards) do
				local _joker = v.config.center.key
				local joker_txt = G.localization.descriptions.Joker[_joker]
				local joker_desc = ''
				for i = 1, #joker_txt.text do
					joker_desc = joker_desc .. ' ' .. joker_txt.text[i]
				end
				_,n = joker_desc:gsub("%S+", "")
				card.ability.extra.word_count = card.ability.extra.word_count + n / 2
            end
			card.ability.extra.word_count = math.floor(card.ability.extra.word_count-0.5)
		end
	end,
    calculate = function(self,card,context)
        if context.joker_main then
			if context.cardarea == G.jokers then
				return {
					mult = card.ability.extra.word_count
				}
			end
        end
    end,
    
}

SMODS.Joker{ -- 24 Karat
    key = 'karat', --joker key
    loc_txt = { -- local text
        name = '24 Karat',
        text = {
          'At the end of the round {C:attention}Gold Cards{} give {C:money}$#2#{}',
		  'times {C:attention}Percentage of {C:attention}Gold Cards{} in {C:attention}Full Deck',
		  '{C:inactive}(currently {C:money}$#1#{C:inactive})'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		gold_tally = 0,
		cur_dollar = 0,
		max_dollar = 24
      }
    },
	loc_vars = function(self,info_queue,center)
		info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        return {vars = {
		
		center.ability.extra.cur_dollar or 0, center.ability.extra.max_dollar
		
		}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.jokers then
			card.ability.extra.gold_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_gold then card.ability.extra.gold_tally = card.ability.extra.gold_tally+1 end
            end
		end
		card.ability.cur_dollar = math.floor(card.ability.extra.gold_tally / (G.playing_cards and #G.playing_cards or 52) * card.ability.extra.max_dollar)
	end,
	calculate = function(self,card,context)
		if context.end_of_round then
			if context.cardarea == G.hand then
				if context.other_card.ability.effect == "Gold Card" then
					if not context.other_card.debuff then
						return {
							h_dollars = card.ability.cur_dollar,
							card = context.other_card
						}
					end
				end
			end
		end
    end,
    
}

SMODS.Joker{ -- Greeting joker
    key = 'greeting_joker', --joker key
    loc_txt = { -- local text
        name = 'Greeting Joker',
        text = {
          'When drawing cards to your hand',
		  'the {C:attention}First Card{} is a {C:attention}Face Card{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 3, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		faced = false
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.total_mult,center.ability.extra.word_count}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.hand_drawn then
			if card.ability.extra.faced == true then
				card.ability.extra.faced = false
				return {
						message = 'Hello!',
						colour = G.C.CHIPS,
						card = card
					}
			end
		end
		
		if context.setting_blind or context.open_booster or context.discard or context.after then
			if G.deck.cards and G.deck.cards[1] and #G.deck.cards then
				local temp_card = G.deck.cards[#G.deck.cards]
				
				if temp_card:is_face() then 
					card.ability.extra.faced = true
					return
				end
			
				if temp_card and not temp_card:is_face() then
					card.ability.extra.faced = false
					for i = 2, #G.deck.cards -1 do
						if G.deck.cards[i]:is_face() then
							G.deck.cards[#G.deck.cards], G.deck.cards[i] = G.deck.cards[i], temp_card
							card.ability.extra.faced = true
							break
						end
					end
				end
			end
		end
    end,
    
}

SMODS.Joker{ --Oven Mitt
    key = 'oven_mitt', --joker key
    loc_txt = { -- local text
        name = 'Oven Mitt',
        text = {
			'{C:mult}+#2#{} Mult per {C:attention}Scored Card',
			'when score is {E:1,C:attention}Burning',
			'{C:inactive}(currently {C:mult}+#1#{C:inactive} Mult)'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		overcook = 0,
		mult = 1,
		scored = 0,
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.overcook, center.ability.extra.mult}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.before and context.scoring_hand then
			card.ability.extra.scored = #context.scoring_hand
		end
		if context.joker_main then
			if card.ability.extra.overcook > 0 then
				return {
						mult = card.ability.extra.overcook
					}
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			if G.ARGS.score_intensity.flames > 0 then
				card.ability.extra.overcook = card.ability.extra.overcook + (card.ability.extra.mult * card.ability.extra.scored)
				return {
					message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult * card.ability.extra.scored}},
					colour = G.C.MULT
				}
			end
		end
    end,
    
}

SMODS.Joker{ -- Alloyed Joker
    key = 'alloyed-joker', --joker key
    loc_txt = { -- local text
        name = 'Alloyed Joker',
        text = {
			"Each {C:attention}Gold Card{} held in hand",
            "gives {X:mult,C:white} X#1# {} Mult, and each {C:attention}Steel Card",
			"gives {C:money}$#2#{} if held in hand",
            "at end of round",
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		Xmult = 1.5,
		dollars = 3
      }
    },
	loc_vars = function(self,info_queue,center)
		info_queue[#info_queue+1] = G.P_CENTERS.m_gold
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return {vars = {center.ability.extra.Xmult, center.ability.extra.dollars}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.end_of_round then
			if context.cardarea == G.hand then
				if context.other_card.ability.effect == "Steel Card" then
					if not context.other_card.debuff then
						return {
							h_dollars = card.ability.extra.dollars,
							card = context.other_card
						}
					end
				end
			end
		else
			if context.individual and context.cardarea == G.hand then
				if context.other_card.ability.effect == "Gold Card" then
					if context.other_card.debuff then
						return {
							message = localize('k_debuffed'),
							colour = G.C.RED,
							card = context.other_card,
						}
					else
						return {
							x_mult = card.ability.extra.Xmult,
							card = context.other_card
						}
					end
				end
			end	
		end
    end,
    
}

SMODS.Joker{ -- Minesweeper
    key = 'minesweeper', --joker key
    loc_txt = { -- local text
        name = 'Minesweeper',
        text = {
			"For each scored card Ranked {C:attention}8{} or less",
			"({C:attention}Ace{} = {C:attention}1{}) will give {C:chips}+#1#{} Chips {X:attention,C:white}XRank{}",
			"{C:green}Rank {X:green,C:white}X#2#{}{C:green} in #3#{} chance to {E:1,C:attention}Destroy{} scored card"
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 7, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		Xchips = 30,
		odds = 8,
		Kablooey = false
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xchips, G.GAME.probabilities.normal, center.ability.extra.odds}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.cardarea == G.play and context.individual then
			local rank = context.other_card:get_id()
			if rank and ((rank < 9 and rank > 0) or rank == 14) then
				return {
					chips = (rank == 14 and 1 or rank) * card.ability.extra.Xchips,
					card = context.blueprint_card or card
				}
			end
		end	
		if context.destroying_card and not context.blueprint and context.cardarea == G.play then
			local rank = context.destroy_card:get_id()
			if rank and ((rank == 14 and pseudorandom('minesweeper') < G.GAME.probabilities.normal / card.ability.extra.odds) or
              (rank > 0 and rank < 9 and pseudorandom('minesweeper') < ((rank - 1) * G.GAME.probabilities.normal) / card.ability.extra.odds)) then
				return {
					message = 'Kablooey!',
					delay = 0.45,
					remove = true,
					card = context.destroy_card
				}
			end
		end
    end,
    
}

SMODS.Joker{ -- Roast Joker
    key = 'roast_joker', --joker key
    loc_txt = { -- local text
        name = 'Roast Joker',
        text = {
			'Increases in value by {C:money}$#1#{} for each',
			'{C:attention}Remaining Hand{} when score is {E:1,C:attention}Burning'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 9, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		value = 2
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.value}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.end_of_round and context.cardarea == G.jokers then
			if G.ARGS.score_intensity.flames > 0 then
				card.ability.extra_value = card.ability.extra_value + (card.ability.extra.value * G.GAME.current_round.hands_left)
                card:set_cost()	
				return {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
			end
		end
    end,
    
}

SMODS.Joker{ -- Card House
    key = 'house_of_cards', --joker key
    loc_txt = { -- local text
        name = "House of Cards",
        text = {
          "This Joker gains {C:chips}Chips{} equal to {C:attention}Chip Score",
          "of each scored card, resets when",
		  '{C:attention}Cards Scored Previously{} are scored',
		  '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 3, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		cards = {},
		chips = 0,
		collapse_check = false
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chips}} --#1# is replaced with card.ability.extra.mult
    end,
     
	calculate = function(self,card,context)
		if context.joker_main and (card.ability.extra.chips > 0) then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
				colour = G.C.CHIPS
			}
		end
		if context.individual and context.cardarea == G.play and
		not context.other_card.debuff and not context.blueprint then
			if card.ability.extra.cards and #card.ability.extra.cards > 0 then
				for i = 1, #card.ability.extra.cards do
					 if context.other_card == card.ability.extra.cards[i] then
						card.ability.extra.chips = 0
						card.ability.extra.cards = {}
						return {
							message = 'Collapsed!',
							card = card,
							delay = 0.45, 
							colour = G.C.RED
						}
					 end
				end
			end
			card.ability.extra.chips = card.ability.extra.chips + context.other_card:get_chip_bonus()
			table.insert(card.ability.extra.cards, context.other_card)
			return {
				message = localize('k_upgrade_ex'),
				card = card,
				colour = G.C.CHIPS
			}
		end
    end,
    
}

SMODS.Joker{ -- Memory Card
    key = 'memory_card', --joker key
    loc_txt = { -- local text
        name = "Memory Card",
        text = {
          "{C:chips}+#3#{} Chips when run is {C:chips}Saved",
           "with at least {C:attention}#2#{} empty joker slots",
		  '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 7, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		chips = 0,
		in_booster = false,
		amount = 8,
		jokers = 2,
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chips, center.ability.extra.jokers, center.ability.extra.amount}} --#1# is replaced with card.ability.extra.mult
    end,
     
	set_ability = function(self, card, initial, delay_sprites)
		local H = card.T.h
		if card.config.center.discovered or card.bypass_discovery_center then 
			H = H/1.2
			card.T.h = H
		end
	end,
	set_sprites = function(self, card, front)
		if card.config.center then 
			if card.config.center.set then
				if card.config.center.discovered or card.bypass_discovery_center then
					card.children.center.scale.y = card.children.center.scale.y/1.2
				end
			end
		end
	end,
	load = function(self, card, card_table, other_card)
		local scale = 1
		local H = G.CARD_H
		local W = G.CARD_W
		card.T.h = H*scale/1.2*scale
        card.T.w = W*scale
	end,
	calculate = function(self,card,context)
		if context.joker_main and (card.ability.extra.chips > 0) then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
				colour = G.C.CHIPS
			}
		end
		
		if context.open_booster then card.ability.extra.in_booster = true end
		
		if (context.ending_shop or context.open_booster or context.skipping_booster or
			context.reroll_shop or context.hand_drawn or (context.end_of_round and context.other_card == card) or
			context.using_consumeable or context.skip_blind or context.playing_card_added or context.card_added)  and
		not card.debuff and not context.blueprint then
		
			if (G.jokers.cards and (G.jokers.config.card_limit - #G.jokers.cards) < card.ability.extra.jokers) or 
			((context.skipping_booster or context.using_consumeable or context.playing_card_added or context.card_added) and card.ability.extra.in_booster == false) then return end
			
			if not context.open_booster then card.ability.extra.in_booster = false end
			
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.amount
			return {
				message = localize('k_saved_ex'),
				card = card,
				colour = G.C.CHIPS
			}
		end
    end,
    
}

SMODS.Joker{ -- Jane
    key = 'fem_jack', --joker key
    loc_txt = { -- local text
        name = 'Jane',
        text = {
          '{C:attention}10s{} act like {C:attention}Jacks{}'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {}} --#1# is replaced with card.ability.extra.mult
    end,
     
    
}

local Getid_old = Card.get_id
function Card:get_id() -- modifier for fem jack "Jane"
	local ret = Getid_old(self)
	if ret == 10 and next(find_joker("j_KMJS_fem_jack")) then ret = 11 end
	return ret
end

local isface_old = Card.is_face
function Card:is_face(from_boss) -- modifier for fem jack "Jane"
	if self.debuff and not from_boss then return end
	local id = Getid_old(self)
	local ret = isface_old(self, from_boss)
	if (not ret or ret == false) and id == 10 and next(find_joker("j_KMJS_fem_jack")) then
		return true
	end
	return ret
end

SMODS.Joker{ -- Joker? HARDLY KNOW HER!!
    key = 'barely_knower', --joker key
    loc_txt = { -- local text
        name = "Hardly Know 'er",
        text = {
          'Repeats every {C:attention}Joker{} with {C:attention}"er"',
		  'at the end of its name',
		  "{s:0.8}Hardly Know 'er excluded",
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		repetitions = 1
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {}} --#1# is replaced with card.ability.extra.mult
    end,
	calculate = function(self,card,context)
		if context.retrigger_joker_check and context.cardarea == G.jokers and context.other_card.config and context.other_card.config.center.key ~= self.key then
            if string.sub(G.localization.descriptions.Joker[context.other_card.config.center.key].name, -2) == "er" or
			string.sub(context.other_card.ability.name, -2) == "er" then
				return {
					message = localize("k_again_ex"),
					repetitions = card.ability.extra.repetitions,
					message_card = card,
				}
			end
        end
    end,
    
}

SMODS.Joker{ -- I want a refund
    key = 'receipt', --joker key
    loc_txt = { -- local text
        name = 'Receipt',
        text = {
          'Sell Jokers and Consumables',
		  'for {C:attention}Purchase Value'
        },
        --[[unlock = {
            'Die on the third ante',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 1, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
	loc_vars = function(self,info_queue,center)
        return {
			vars = {
			}
		} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in ipairs(G.jokers.cards) do
				if v.set_cost then 
					--v.ability.extra_value = (v.ability.extra_value or 0) + self.ability.extra
					v:set_cost()
				end
			end
			for k, v in ipairs(G.consumeables.cards) do
				if v.set_cost then 
					--v.ability.extra_value = v.cost - v.ability.extra_value
					v:set_cost()
				end
			end            
		return true end }))
		
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in ipairs(G.jokers.cards) do
				if v.set_cost then 
					--v.ability.extra_value = (v.ability.extra_value or 0) + self.ability.extra
					v:set_cost()
				end
			end
			for k, v in ipairs(G.consumeables.cards) do
				if v.set_cost then 
					--v.ability.extra_value = v.cost - v.ability.extra_value
					v:set_cost()
				end
			end            
		return true end }))
	end,
    
}

local Setcost_old = Card.set_cost
function Card:set_cost() 			--Receipt Joker modification
	local ret = Setcost_old(self)
	if next(find_joker("j_KMJS_receipt")) then self.sell_cost = self.cost + self.ability.extra_value end
	return ret
end

SMODS.Joker{ -- Stained Glass (another mod has one of these, but mine works differently)
    key = 'stained_glass', --joker key
    loc_txt = { -- local text
        name = 'Stained Glass Joker',
        text = {
          'Played {C:attention}Glass Cards{}',
          ' become {C:dark_edition}Polychrome'
        },
        --[[unlock = {
            'Die on the third ante',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 9, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
	loc_vars = function(self,info_queue,center)
		if not (center.edition and center.edition.key == "e_polychrome") then
            -- prevent tooltip from showing up twice
            info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        end
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        return {
			vars = {
			}
		} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local thunk = 0 -- copied from neato's joker werewolf, love this joke
            for k, v in ipairs(context.full_hand) do
                if v.ability.name == 'Glass Card' and v.ability.edition ~= "Polychrome" then
                    thunk = thunk + 1
                    v:set_edition({polychrome = true}, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
            end
            if thunk > 0 then
                return{
                    message = 'Stained!',
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end,
    
}

SMODS.Joker{ -- BBQ
    key = 'barbeque', --joker key
    loc_txt = { -- local text
        name = 'BarbeQ',
        text = {
			"Adds one {C:attention}Enhanced Queen",
            "to deck at end of round",
            "when score is {E:1,C:attention}Burning",
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 6, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.end_of_round and context.cardarea == G.jokers  and G.ARGS.score_intensity.flames > 0 then
			playing_card_joker_effects({true})
			G.E_MANAGER:add_event(Event({
                    func = function() 
						local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('bbq_create'))
						local cen_pool = {}
						for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
							if v.key ~= 'm_stone' then 
								cen_pool[#cen_pool+1] = v
							end
						end
                        local front = G.P_CARDS[_suit..'_Q']
						local center = pseudorandom_element(cen_pool, pseudoseed('bbq_card'))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, center, {playing_card = G.playing_card})
                        card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                        return true
                    end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Queen", colour = G.C.SECONDARY_SET.Enhanced})

                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end}))
                    draw_card(G.play,G.deck, 90,'up', nil)  

                playing_card_joker_effects({true})
		end
    end,
    
}

SMODS.Joker{ -- Lemur
    key = 'lemurcatta', --joker key
    loc_txt = { -- local text
        name = 'Ring Tailed Lemur',
        text = {
			"When {C:attention}The Sun{} Card is used",
			"affected cards permanently",
			"gain {C:mult}+#1#{} Mult"
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 8, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		amount = 13
      }
    },
	loc_vars = function(self,info_queue,center)
		info_queue[#info_queue+1] = G.P_CENTERS.c_sun
        return {vars = {center.ability.extra.amount}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.using_consumeable then
			if context.consumeable.ability.name == 'The Sun' then
				local _cards = {}
				for _, v in pairs(G.hand.highlighted) do
				table.insert(_cards, v)
				end
				for i=1, #_cards do
					G.E_MANAGER:add_event(
						Event({trigger = 'after',
						delay = 0.3,
						func = function() 
							_cards[i].ability.perma_mult = _cards[i].ability.perma_mult or 0
							_cards[i].ability.perma_mult = _cards[i].ability.perma_mult + card.ability.extra.amount
							_cards[i]:juice_up()
							return true 
					end }))
				end
				return {
					extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
					colour = G.C.MULT,
					card = context.blueprint_card or card
				}
			end
		end
    end,
    
}

SMODS.Joker{ -- Lambda Cache
    key = 'lambda_cache', --joker key
    loc_txt = { -- local text
        name = 'Lambda Cache',
        text = {
			"{C:purple}+#1#{} Hands or Discards",
			"when {C:attention}Blind{} is selected"
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 9, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		loot = 2
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.loot}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            G.E_MANAGER:add_event(Event({func = function()
				local discards = 0
				local hands = 0
				for i = 1, card.ability.extra.loot do
					if pseudorandom('lambda') < 0.5 then
						hands = hands + 1
					else
						discards = discards + 1
					end
				end
				if hands ~= 0 then 
				ease_hands_played(hands)
				--card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {hands}}}) 
				end
				if discards ~= 0 then 
				ease_discard(discards)
				--card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_discards', vars = {discards}}}) 
				end
				if context.blueprint then
					context.blueprint_card:juice_up()
				else
					card:juice_up()
				end
			return true end }))
		end
    end,
    
}

SMODS.Joker{ -- Hyperactive
    key = 'hyperactive', --joker key
    loc_txt = { -- local text
        name = 'Hyperactive Joker',
        text = {
			'{X:red,C:white}X#1#{} mult if joker is not',
			'in previous position after',
			'{C:attention}Drawing from Deck',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 8, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		last_position = 9999,
		cur_pos = 0,
		Xmult = 3
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult, center.ability.extra.last_position, center.ability.extra.cur_pos}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	update = function(self, card, dt)
		--[[if card.loaded then
			card:juice_up()
			local eval = function() return (card.ability.extra.last_position and card.ability.extra.cur_pos) and not G.RESET_JIGGLES end
			juice_card_until(card, eval, true)
		end]]
		if G.STAGE == G.STAGES.RUN and G.jokers and #G.jokers.cards ~= 0 then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					card.ability.extra.cur_pos = i
					break
				end
			end
		end	
	end,
    calculate = function(self,card,context)
		if context.hand_drawn and not context.blueprint then
			card.ability.extra.last_position = card.ability.extra.cur_pos
			local eval = function() return (card.ability.extra.last_position == card.ability.extra.cur_pos) end
			juice_card_until(card, eval, true)
		end
		if context.joker_main and card.ability.extra.last_position ~= card.ability.extra.cur_pos then
			return{
				xmult = card.ability.extra.Xmult
			}
		end
    end,
    
}

SMODS.Joker{ -- Dark Tar
    key = 'dark_tar', --joker key
    loc_txt = { -- local text
        name = 'Dark Tar',
        text = {
			'If Played Hand is a {C:attention}Four of a Kind',
			'scored cards become {C:dark_edition}Negative{}',
			'and reduces hand size by {C:red}#2#{}',
			'{C:inactive}(Currently {}{C:red}-#1#{}{C:inactive} hand size)'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 8, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    --soul_pos = {x = 9, y = 3},
	config = { 
      extra = {
		h_size = 1,
		h_mod = 1
      }
    },
	loc_vars = function(self,info_queue,center)
		if not (center.edition and center.edition.key == "e_negative") then
            -- prevent tooltip from showing up twice
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        end
        return {vars = {center.ability.extra.h_size, center.ability.extra.h_mod}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.before and (next(context.poker_hands['Four of a Kind'])) and not context.blueprint then
            local thunk = 0 -- copied from neato's joker werewolf, love this joke
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.edition ~= "Negative" then
                    thunk = thunk + 1
                    v:set_edition({negative = true}, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
					
                end
            end
            if thunk > 0 then
                return{
                    message = localize('negative', 'labels'),
                    colour = G.C.DARK_EDITION
                }
			end
		end
		if context.end_of_round and not context.individual and not context.blueprint then
			card.ability.extra.h_size = card.ability.extra.h_size + card.ability.extra.h_mod
			G.hand:change_size(-card.ability.extra.h_mod)
			return {
					message = localize{type='variable',key='a_handsize_minus',vars={card.ability.extra.h_mod}},
					colour = G.C.RED
				}
		end
    end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.h_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.h_size)
	end,
	--[[set_sprites = function(self, card, front)
		
	end,
	draw = function(self, card, layer)
	
		G.shared_shadow = card.sprite_facing == 'front' and card.children.center and card.children.back

		--Draws only back shadow
		if not card.no_shadow and G.SETTINGS.GRAPHICS.shadows == 'On' and((layer == 'shadow') and (card.ability.effect ~= 'Glass Card' and not card.greyed) and ((card.area and card.area ~= G.discard and card.area.config.type ~= 'deck') or not card.area or card.states.drag.is)) then
			card.shadow_height = 0*(0.08 + 0.4*math.sqrt(card.velocity.x^2)) + ((((card.highlighted and card.area == G.play) or card.states.drag.is) and 0.35) or (card.area and card.area.config.type == 'title_2') and 0.04 or 0.1)
			G.shared_shadow:draw_shader('dissolve', card.shadow_height)
		end
		
		if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
			if card.config.center.soul_pos and (card.config.center.discovered or card.bypass_discovery_center) then
				
				card.children.floating_sprite:remove()
				
				local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
				local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
				
				card.children.floating_sprite:draw_shader('dissolve', -2, nil, nil, card.children.center, 2*scale_mod, 2*rotate_mod)
			end
		end
	end,]]
    
}

SMODS.Joker{ -- Alt Codes
    key = 'alt_code', --joker key
    loc_txt = { -- local text
        name = 'Alt Codes',
        text = {
			'Scored {V:1}#3#{} {C:attention}#2#{}',
			'cards give {C:mult}+#1# Mult',
			'Changes every hand played'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		mult = 6,
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult, 
		G.GAME.current_round.altcode_card.face and 'face' or 'non-face', 
		string.sub(G.GAME.current_round.altcode_card.suit, 1, -2),
		colours = {
                    G.C.SUITS[G.GAME.current_round.altcode_card.suit]
                }}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.cardarea == G.play and context.individual then
			if ((context.other_card:is_face() and G.GAME.current_round.altcode_card.face) or (not context.other_card:is_face() and not G.GAME.current_round.altcode_card.face))
			and context.other_card:is_suit(G.GAME.current_round.altcode_card.suit) then
				return {
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
    end,
    
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.altcode_card = { suit = 'Hearts', face = true }
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
	-- The suit changes every round, so we use reset_game_globals to choose a suit.
	G.GAME.current_round.altcode_card = { suit = 'Hearts', face = true }
	local valid_altcode_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then -- Abstracted enhancement check for jokers being able to give cards additional enhancements
			valid_altcode_cards[#valid_altcode_cards + 1] = v
		end
	end
	if valid_altcode_cards[1] then
		local altcode_card = pseudorandom_element(valid_altcode_cards, pseudoseed('2cas' .. G.GAME.round_resets.ante))
		G.GAME.current_round.altcode_card.suit = altcode_card.base.suit
		G.GAME.current_round.altcode_card.face = pseudorandom('altface') < 0.5
	end
end

SMODS.Joker{ -- Jelly Bean Jar
    key = 'jelly_bean_jar', --joker key
    loc_txt = { -- local text
        name = 'Guessing Jar',
        text = {
			'Guess the number {C:inactive}(100-999){} using the {C:attention}First Three{} numbered cards',
			'({C:attention}Ace{} = {C:attention}1{}, {C:attention}10{} = {C:attention}0{}) to gain {C:attention}#1# Juggler Tags{} during {C:attention}Boss Blind',
			'{C:chips}+Chips{} equal to difference',
			'{C:attention}Tag{} amount decreases each round until {C:green}WON',
			'resets when {C:attention}Boss Blind{} is defeated'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 4, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		winning_num = math.random(100, 999),
		guess = 0,
		rounds_left = 3,
		has_won = false
      }
    },
	loc_vars = function(self,info_queue,center)
		info_queue[#info_queue+1] = {key = 'tag_juggle', set = 'Tag'}
        return {vars = {center.ability.extra.rounds_left, center.ability.extra.winning_num}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if G.GAME.blind.boss then
			card.ability.extra.has_won = false
			card.ability.extra.rounds_left = 3
			card.ability.extra.winning_num = math.random(100, 999)
			return {
					message = localize('k_reset'),
				}
			elseif not card.ability.extra.has_won then
			card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
			end
		end
		if context.before and context.cardarea == G.jokers and card.ability.extra.has_won == false
		and not context.repetition and not context.blueprint then
			for i = 1, (#context.full_hand - 2) do
				if not (context.full_hand[i]):is_face() and (context.full_hand[i]).ability.name ~= 'Stone Card' then
					for j = 0, 2 do
						local num = 0
						if (context.full_hand[i + j]):get_id() == 14 then
						num = 1
						elseif (context.full_hand[i + j]):get_id() < 10  and (context.full_hand[i + j]):get_id() > 0 then
						num = (context.full_hand[i + j]):get_id()
						end
						card.ability.extra.guess = card.ability.extra.guess .. num
					end
				break
				end
			end
		end
		if context.setting_blind and G.GAME.blind.boss and card.ability.extra.has_won and not self.getting_sliced then
			for i=1, card.ability.extra.rounds_left do
				G.E_MANAGER:add_event(Event({
					delay = 0.2,
					func = (function()
						add_tag(Tag('tag_juggle'))
						play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
						play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
						return true
					end)
				}))
			end
		end
		if context.joker_main and card.ability.extra.has_won == false then
			if tonumber(card.ability.extra.guess) < 100 then return end
			local chipscore = card.ability.extra.guess - card.ability.extra.winning_num
			card.ability.extra.guess = 0
			if chipscore == 0 then
				if G.GAME.blind.boss then
					for i=1, card.ability.extra.rounds_left do
						G.E_MANAGER:add_event(Event({
							delay = 0.2,
							func = (function()
								add_tag(Tag('tag_juggle'))
								play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
								play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
								return true
							end)
						}))
					end
				end
				card.ability.extra.has_won = true
				G.E_MANAGER:add_event(Event({
					blocking = false,
					delay = 0.3,
                    func = (function()
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
						play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
				return {
				message = localize('ph_you_win'),
				colour = G.C.GREEN
			}
			end
			if chipscore < 0 then
			chipscore = chipscore * -1
			
			--local factor = 10^(card.ability.extra.rounds_left - 1)
			--chipscore = math.floor(chipscore / factor) * factor
			
			end
			return {
				message = localize{type='variable',key='a_chips',vars={chipscore}},
				chip_mod = chipscore,
				colour = G.C.CHIPS
			}
		end
    end,
    
}

SMODS.Joker{ -- AK47
    key = 'ak47', --joker key
    loc_txt = { -- local text
        name = 'AK-47',
        text = {
			"Combines {C:attention}#1#{} random cards' {C:Money}costs",
			"into {C:mult}Mult{} if played hand contains",
			'an {C:attention}Ace{}, {C:attention}King{}, {C:attention}4{}, and {C:attention}7{}'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 2, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
	  mag_size = 30,
	  all_cards = {},
	  loaded = false
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mag_size}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.before and context.cardarea == G.jokers then
			local a,k,f,s = false,false,false,false
			for _, v in pairs(G.play.cards) do
				local num = v:get_id()
				if num == 14 then
				a = true
				end
				if num == 13 then
				k = true
				end
				if num == 4 then
				f = true
				end
				if num == 7 then
				s = true
				end
			end
			if a and k and f and s then
			card.ability.extra.loaded = true
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Cha-Chak!'})
			G.E_MANAGER:add_event(Event({
                    func = (function()
                        play_sound('KMJS_ak47_boltpull', math.random()*0.2 + 0.9, 1)
                        return true
                    end)
                }))
			card:juice_up()
			end
		end
		if context.joker_main and card.ability.extra.loaded then
			card.ability.extra.all_cards = {}
			if G.jokers.cards and #G.jokers.cards > 0 then
				for _, v in pairs(G.jokers.cards) do
					if v ~= card then 
						table.insert(card.ability.extra.all_cards, v)
					end
				end
			end
			if G.consumeables.cards and #G.consumeables.cards > 0 then
				for _, v in pairs(G.consumeables.cards) do
					table.insert(card.ability.extra.all_cards, v)
				end
			end
			if G.hand.cards and #G.hand.cards > 0 then
				for _, v in pairs(G.hand.cards) do
					table.insert(card.ability.extra.all_cards, v)
				end
			end
			if G.play.cards and #G.play.cards > 0 then
				for _, v in pairs(G.play.cards) do
					table.insert(card.ability.extra.all_cards, v)
				end
			end
			
			local total = 0
			
			for i = 1, card.ability.extra.mag_size do
				local target = pseudorandom_element(card.ability.extra.all_cards, pseudoseed('ak_shootout'))
				G.E_MANAGER:add_event(Event({
					blocking = false,
					delay = 0.2,
                    func = (function()
                        play_sound('KMJS_ak47_shoot', math.random()*0.2 + 0.9, 0.2)
						card:juice_up()
                        return true
                    end)
                }))
				card_eval_status_text(target, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {target.cost}}, colour = G.C.ORANGE})
				total = total + target.cost
			end
			return {
				mult = total,
				colour = G.C.DARK_EDITION,
				card = context.blueprint_card or card
			}
		end
		if context.after then
			card.ability.extra.loaded = false
		end
    end,
    
}

SMODS.Joker{ -- Deaeth card
    key = 'deathcard', --joker key
    loc_txt = { -- local text
        name = 'Deathcard Joker',
        text = {
          'Every {C:attention}#2#{} jokers destroyed',
		  'one of the destroyed jokers will be',
		  'created with a random {C:dark_edition}Edition',
		  '{C:inactive}( {C:attention}#1#{}{C:inactive} remaining)'
        },
        --[[unlock = {
            'Die on the third ante',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		discards = 3,
		cur_jokers = {},
		stored_jokers = {}
      }
    },
	loc_vars = function(self,info_queue,center)
		if not (center.edition and center.edition.key == "e_polychrome") then
            info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        end
		if not (center.edition and center.edition.key == "e_negative") then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        end
		if not (center.edition and center.edition.key == "e_foil") then
            info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        end
		if not (center.edition and center.edition.key == "e_holo") then
            info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        end
        return {
			vars = {
				center.ability.extra.discards - (#center.ability.extra.stored_jokers or 0),
				center.ability.extra.discards
			}
		} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	calculate = function(self,card,context)
		if (context.selling_card or (context.card_added and context.cardarea == G.jokers)) and not context.blueprint then
			card.ability.extra.cur_jokers = {}
			for k, v in pairs(G.jokers.cards) do
				table.insert(card.ability.extra.cur_jokers, v.config.center.key)
			end
		end
		if (context.setting_blind and context.cardarea == G.jokers) or context.joker_main then
			if not context.blueprint then
				local inserted = false
				for k, v in pairs(card.ability.extra.cur_jokers) do
					local exists = false
					for _, existing in pairs(G.jokers.cards) do
						if existing.config.center.key == v then
							exists = true
							break
						end
					end

					if not exists then
						table.insert(card.ability.extra.stored_jokers, v)
						inserted = true
					end
				end
				
				card.ability.extra.cur_jokers = {}
				for k, v in pairs(G.jokers.cards) do
					table.insert(card.ability.extra.cur_jokers, v.config.center.key)
				end
			
				if inserted and (#card.ability.extra.stored_jokers or 0) < card.ability.extra.discards then
					return {
						message = localize('k_copied_ex'),
						colour = G.C.RED,
						delay = 0.45, 
						card = card
					}
				end
			end
			if (#card.ability.extra.stored_jokers or 0) >= card.ability.extra.discards then
				--copycard
				local edition = poll_edition('deathcard_edition', nil, false, true)
				local _joker = create_card('Joker', G.jokers, nil, nil, nil, nil, pseudorandom_element(card.ability.extra.stored_jokers, pseudoseed('deathcard')), 'deth')
				_joker:set_edition(edition, true)
				_joker:add_to_deck()
				G.jokers:emplace(_joker)
				_joker:start_materialize()
				G.GAME.joker_buffer = 0
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.DARK_EDITION})
				
				if not context.blueprint then 
				card.ability.extra.stored_jokers = {}
				end
			end
		end
    end,
	add_to_deck = function(self, card, from_debuff)
		if G.jokers then
			card.ability.extra.cur_jokers = {}
			for k, v in pairs(G.jokers.cards) do
				table.insert(card.ability.extra.cur_jokers, v.config.center.key)
			end
		end
	end,
}

SMODS.Joker{ -- Self insert lol
    key = 'kingmaxthe2', --joker key
    loc_txt = { -- local text
        name = 'Kingmaxthe2',
        text = {
			'{X:red,C:white}X#1#{} Mult for {C:attention}Every{} card with',
			'{C:green}Green{} in the description',
			'{C:inactive}(Currently {X:red,C:white}X#2#{}{C:inactive} Mult)'
        },
        unlock = {
            "Find this Joker",
            "from the {C:spectral}Soul{} card",
        }
    },
    atlas = 'Jokers', --atlas' key
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 20, --cost
    unlocked = false, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    soul_pos = {x = 8, y = 3},
	config = { 
      extra = {
		xmult = 1,
		greencount = 1
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.greencount * center.ability.extra.xmult}} --#1# is replaced with card.ability.extra.mult
    end,
    update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.jokers then
			card.ability.extra.greencount = 0
			local total_cards = {}
			for _, v in pairs(G.jokers.cards) do
				table.insert(total_cards, v)
			end
			for _, v in pairs(G.consumeables.cards) do
				table.insert(total_cards, v)
			end
			for k, v in pairs(total_cards) do
				local _joker = v.config.center.key or 'j_joker'
				local _set = v.config.center.set or 'Joker'
				local joker_txt = G.localization.descriptions[_set][_joker]
				local joker_desc = ''
				for i = 1, #joker_txt.text do
					if string.find(string.lower(joker_txt.text[i]), "green") or string.find(string.lower(joker_txt.text[i]), ":cry_code") then
						card.ability.extra.greencount = card.ability.extra.greencount + 1
						break
					end
				end
            end
			for k, v in pairs(G.playing_cards) do
				if v.config.center ~= G.P_CENTERS.c_base then
					local _joker = v.config.center_key
					local _set = v.ability.set
					local joker_txt = G.localization.descriptions[_set][_joker]
					local joker_desc = ''
					for i = 1, #joker_txt.text do
						if string.find(string.lower(joker_txt.text[i]), "green") then
							card.ability.extra.greencount = card.ability.extra.greencount + 1
							break
						end
					end
				end
			end
		end
	end,
    calculate = function(self,card,context)
        if context.joker_main then
			if context.cardarea == G.jokers then
				return {
					xmult = card.ability.extra.xmult * card.ability.extra.greencount
				}
			end
        end
    end,
    
}

SMODS.Joker{ -- Gravel Eater
    key = 'gravelslug', --joker key
    loc_txt = { -- local text
        name = 'Gravel Eater',
        text = {
			'{C:attention}Stone Cards{} become {C:dark_edition}Foils{},',
			'give {X:mult,C:white}X#1#{} Mult, and are',
			'destroyed when scored'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 7, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		Xmult = 3
      }
    },
	loc_vars = function(self,info_queue,center)
		if not (center.edition and center.edition.key == "e_foil") then
            -- prevent tooltip from showing up twice
            info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        end
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.before and not context.blueprint then
			local cyan = false
            for k, v in ipairs(context.full_hand) do
                if v.ability.name == 'Stone Card' and v.ability.edition ~= "Foil" then
                    v:set_edition({foil = true}, true)
					local cyan = true
                end
				if cyan then card:juice_up() end
            end
        end
		if context.individual and context.cardarea == G.play then
			if context.other_card.ability.name == "Stone Card" then
				return {
					xmult = card.ability.extra.Xmult,
					card = context.other_card
				}
			end
		end
		if context.destroy_card and context.cardarea == G.play and not context.blueprint then
			if context.destroy_card.ability.name == "Stone Card" then
				return {
					message = localize('k_eaten_ex'),
					delay = 0.45,
					remove = true,
					card = context.destroy_card
				}
			end
		end
    end,
}

SMODS.Joker{ -- Barotrauma
    key = 'europan', --joker key
    loc_txt = { -- local text
        name = "Europan Clown",
        text = {
			'{C:green}#1# in #2#{} chance to',
			'{C:attention}Win Blind{} and {C:red}implode',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		odds = 3,
		chance = 400
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.odds * G.GAME.probabilities.normal, center.ability.extra.chance}} --#1# is replaced with card.ability.extra.mult
    end,
     
	calculate = function(self,card,context)
		if context.joker_main then
			G.E_MANAGER:add_event(Event({
				delay = 0.2,
				func = (function()
					local snd = 'KMJS_europa_hit'
					if math.random() < 0.5 then
						snd = snd..'1'
					end
					play_sound(snd, math.random()*0.25 + 1, 1)
					if context.blueprint then
						context.blueprint_card:juice_up()
					else
						card:juice_up()
					end
					return true
				end)
			}))
            if (pseudorandom('europa') < (card.ability.extra.odds * G.GAME.probabilities.normal) / card.ability.extra.chance) then
				G.E_MANAGER:add_event(Event({
					blocking = false,
					func = function()
					  if G.STATE == G.STATES.SELECTING_HAND then
						G.GAME.chips = G.GAME.blind.chips
						G.STATE = G.STATES.HAND_PLAYED
						G.STATE_COMPLETE = true
						end_round()
						return true
					  end
					end
				  }))
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('KMJS_europa_trigger')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					message = 'Praise the Honkmother!',
					colour = G.C.RED,
					card = card
				}
			end
        end
    end,
    
}

SMODS.Joker{ -- Thousandaire
    key = 'thousandaire', --joker key
    loc_txt = { -- local text
        name = 'Thousandaire',
        text = {
			'Scored number cards within {C:attention}#1# Slot(s){} to',
            'the left of a {C:attention}King{} earn {C:money}${} equal to their',
            '{C:chips}Chip{} score divided by distance to {C:attention}King{}',
            '{C:attention}Slots{} = {C:attention}Digits{} in your {C:money}${}'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 2}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		digits = 1
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.digits}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.jokers then
			card.ability.extra.digits = math.floor(math.log10(G.GAME.dollars)) + 1
		end
	end,
    calculate = function(self,card,context)
		if context.individual and context.cardarea == G.play then
			if not context.other_card:is_face() then
				local mons = 0
				for k, v in ipairs(context.full_hand) do
					if v == context.other_card then
						for i = k + 1, k + card.ability.extra.digits do
							if i <= #context.full_hand then
								if context.full_hand[i]:get_id() == 13 then
									mons = math.floor(context.other_card:get_chip_bonus() / (i - k))
								end
							else
								break
							end
						end
						break
					end
				end
				if mons ~= 0 then
					return {
						dollars = mons
					}
				end
			end
		end
    end,
    
}

SMODS.Joker{ -- cone :3
    key = 'yellow_cone', --joker key
    loc_txt = { -- local text
        name = "Yellow Cone",
        text = {
          '{C:attention}Unscored{} cards permanently gain {C:chips}Chips',
		  "equal to double {C:attention}Played Hand's{} {C:mult}Mult",
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 6, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {}} --#1# is replaced with card.ability.extra.mult
    end,
     
	set_ability = function(self, card, initial, delay_sprites)
		local H = card.T.h
		if card.config.center.discovered or card.bypass_discovery_center then 
			H = H/1.2
			card.T.h = H
		end
	end,
	set_sprites = function(self, card, front)
		if card.config.center then 
			if card.config.center.set then
				if card.config.center.discovered or card.bypass_discovery_center then
					card.children.center.scale.y = card.children.center.scale.y/1.2
				end
			end
		end
	end,
	load = function(self, card, card_table, other_card)
		local scale = 1
		local H = G.CARD_H
		local W = G.CARD_W
		card.T.h = H*scale/1.2*scale
        card.T.w = W*scale
	end,
	calculate = function(self,card,context)
		if context.before then
			local scoreMult = G.GAME.hands[context.scoring_name].mult
            for k, v in ipairs(context.full_hand) do
				local scored = false
                for j, b in ipairs(context.scoring_hand) do
					if v == b then
						scored = true
						break
					end
				end
				if not scored then
					if  type(mult) ~= "number" then
						card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.RED})
					else
						G.E_MANAGER:add_event(
							Event({
							func = function() 
								v.ability.perma_bonus = v.ability.perma_bonus or 0
								v.ability.perma_bonus = v.ability.perma_bonus + scoreMult * 2
								return true 
						end }))
						card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
					end
				end
            end
        end
        
    end,
    
}

SMODS.Joker{ --Canine
    key = 'canine', --joker key
    loc_txt = { -- local text
        name = 'Canine',
        text = {
		  '{X:mult,C:white}X#1#{} Mult when poker hand',
		  'contains a {C:attention}King{} and a {C:attention}9{},'
        },
        --[[unlock = {
            'Play a Queen and four Aces',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		Xmult = 2
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.joker_main then
			local _nine = false
			local _king = false
			for k , v in pairs(context.full_hand) do
				if v:get_id() == 13 then _king = true end
				if v:get_id() == 9 then _nine = true end
				if _nine and _king then break end
			end
			if _nine and _king then
				return {
						xmult = card.ability.extra.Xmult,
						card = card
					}
			end
		end
    end,
    
}

SMODS.Joker{ -- Blood janitor
    key = 'blood_janitor', --joker key
    loc_txt = { -- local text
        name = 'Viscera Janitor',
        text = {
			'When at least {C:attention}#1#%{} of {C:hearts}Hearts{}',
			'in deck are {C:attention}Discarded',
			'get a free {C:tarot}Voucher{}',
			'at end of round'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		discards = 0,
		hearts = 13,
		percentage = 0.7
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.percentage * 100}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.jokers then
			card.ability.extra.hearts = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_suit('Hearts') then card.ability.extra.hearts = card.ability.extra.hearts+1 end
            end
		end
	end,
    calculate = function(self,card,context)
		if card.ability.extra.hearts > 0 and not context.blueprint then
			if context.discard then
				if context.other_card:is_suit('Hearts') then
					card.ability.extra.discards = card.ability.extra.discards + 1
					return {
						delay = 0.2,
						message = tostring(math.floor((card.ability.extra.discards/card.ability.extra.hearts)* 100))..'%',
						colour = G.C.SUITS.Hearts
					}
				end
			end
			if context.end_of_round and context.cardarea == G.jokers then
				local cleaned = false
				if card.ability.extra.discards >= (card.ability.extra.hearts * card.ability.extra.percentage) then
					cleaned = true
					G.E_MANAGER:add_event(Event({
                    func = function() 
						--G.ARGS.voucher_tag = G.ARGS.voucher_tag or {}
						local voucher_key = get_next_voucher_key(false)
						--G.ARGS.voucher_tag[voucher_key] = true
						--G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1
						local voucher = SMODS.create_card({key = voucher_key})
						--create_shop_card_ui(card, 'Voucher', G.shop_vouchers)
						voucher:start_materialize()
						G.play:emplace(voucher)
						voucher.cost = 0
						voucher:redeem()
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							func = function() 
								voucher:start_dissolve()
								return true
							end}))
                        return true
                    end}))
				end
				card.ability.extra.discards = 0
				if cleaned then
					return {
							delay = 0.2,
							message = localize('k_voucher'),
							colour = G.C.PURPLE
						}
				end
			end
		end
    end,
    
}

SMODS.Joker{ -- Dog's Ball
    key = 'dogball', --joker key
    loc_txt = { -- local text
        name = "Dog's Ball",
        text = {
			'{X:mult,C:white}X#1#{} Mult when all {C:clubs}Clubs',
			'in hand are {C:attention}played'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 6, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		Xmult = 2
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.mult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'amogus' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
		if context.joker_main then
			local inhand = false
			local inplayed = false
			for k , v in pairs(context.full_hand) do
				if v:is_suit('Clubs') then inplayed = true break end
			end
			for k , v in pairs(G.hand.cards) do
				if v:is_suit('Clubs') then inhand = true break end
			end
			if inplayed and not inhand then
				return {
						xmult = card.ability.extra.Xmult,
						card = card
					}
			end
		end
    end,
    
}

end

if MXconfig.exp then

SMODS.Joker{ -- Whiteboard (ortalab did it first :P)
    key = 'whiteboard', --joker key
    loc_txt = { -- local text
        name = "Whiteboard",
        text = {
			"{X:red,C:white} X#1# {} Mult if all",
			"cards held in hand",
			"are {C:diamonds}#2#{} or {C:hearts}#3#{}",
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 6, y = 4}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
		xmult = 3
      }
    },
	loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.xmult, localize('Diamonds', 'suits_plural'), localize('Hearts', 'suits_plural')}} --#1# is replaced with card.ability.extra.mult
    end,
     
	calculate = function(self,card,context)
		if context.joker_main then
            local red_suits, all_cards = 0, 0
			for k, v in ipairs(G.hand.cards) do
				all_cards = all_cards + 1
				if v:is_suit('Diamonds', nil, true) or v:is_suit('Hearts', nil, true) then
					red_suits = red_suits + 1
				end
			end
			if red_suits == all_cards then 
				return {
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
					Xmult_mod = card.ability.extra.xmult
				}
			end
        end
    end,
    
}


SMODS.Sticker{
	key = 'flammable',
	loc_txt = {
        name = 'Flammable',
        text = {
            "{C:attention}Destroyed{} when",
            "score is {E:1,C:attention}Burning",
        }
    },
	atlas = 'Jokers', pos = { x = 8, y = 4 },
	sets = {
		Joker = true
	},
}

-- Jimbo's wallet stuff

SMODS.Tag{
	key = 'WalletTag',
	loc_txt = {
        name = 'Wallet Tag', --name of card
        text = { --text of card
            "Gives a free",
            "{C:attention}Jimbo's Wallet Pack",
        }
    },
	atlas = 'tags',
    pos = {x = 0, y = 0},
	config = {
		type = 'new_blind_choice',
	},
	Discovered = false,
	no_collection = false,
	min_ante = 2,
	apply = function(self, tag, context)
		if not tag.triggered and tag.config.type == context.type then
			if context.type == 'new_blind_choice' then 
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
				tag:yep('+', G.C.GREEN,function() 
					local key = 'p_KMJS_wallet'
					local card = SMODS.create_card({key = key})
					--local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
					--G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
					card.cost = 0
					card.from_tag = true
					G.FUNCS.use_card({config = {ref_table = card}})
					card:start_materialize()
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				tag.triggered = true
				return true
			end
		end
	end,
}

SMODS.ConsumableType{
    key = 'cash', --consumable type key

    collection_rows = {3,2}, --amount of cards in one page
    primary_colour = G.C.GREEN, --first color
	secondary_colour = G.C.GREEN, --second color
    loc_txt = {
        collection = "Jimbo's Wallet", --name displayed in collection
        name = 'Wallet', --name displayed in badge
        undiscovered = {
            name = 'Not Discovered', --undiscovered name
            text = {"Open this pack",
                    "in an unseeded run",
                    "to learn what it does",} --undiscovered text
        }
    },
    shop_rate = 0, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'JimboWallet', --must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 7, y = 3}
}

SMODS.Booster({ -- I stole jimbo's wallet
    key = 'wallet',
    loc_txt = {
            name = "Jimbo's Wallet",
            text = { "Stuff from Jimbo's wallet" }
        },
    atlas = 'Jokers',
    pos = { x = 6, y = 3 },
    config = { extra = 4, choose = 1 },
    weight = 0,
    cost = 8,
    draw_hand = false,
    unlocked = true,
    discovered = false,
	kind = "wallet",
	create_card = function(self, card, i)
		if pseudorandom('wallet_junk') > 0.4 then
			local tbl = {'j_kmjs_receipt', 
			'j_ortalab_forklift','j_ortalab_mint_condition','j_ortalab_scratch_card','j_ortalab_joker_miles',
			'j_drivers_license', 'j_credit_card', 'j_gift', 'j_business', 'j_loyalty_card', 'j_todo_list', 'j_photograph', 'j_brainstorm'}
			local chosen_joker = "j_joker"
			for i = #tbl, 2, -1 do
				local j = math.random(i)
				tbl[i], tbl[j] = tbl[j], tbl[i]
			end
			local has_joker = false
			for i, j in ipairs(tbl) do
				for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
					if v == j then 
						chosen_joker = j
						has_joker = true
						break
					end
				end
			end
			if has_joker then
				return {
					key = chosen_joker,
					skip_materialize = true,
					soulable = true
				}
			end
		end
        return {
            set = "cash",
			skip_materialize = true
        }
    end
})

SMODS.Consumable{ -- $1
    key = 'one', --key
    set = 'cash', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 0, y = 3}, --position in atlas
    loc_txt = {
        name = '1 Dollar Bill', --name of card
        text = { --text of card
            'Gain $1'
        }
    },
    config = {
        extra = {
		amount = 1
        }
    },
	cost = 1,
    loc_vars = function(self,info_queue, center)
        return {vars = {}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra.amount)
            return true end }))
        delay(0.6)
    end,
	in_pool = function(self, args)
		return true
	end,
}

SMODS.Consumable{ -- $5
    key = 'five', --key
    set = 'cash', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 1, y = 3}, --position in atlas
    loc_txt = {
        name = '5 Dollar Bill', --name of card
        text = { --text of card
            'Gain $5'
        }
    },
    config = {
        extra = {
		amount = 5
        }
    },
	cost = 5,
    loc_vars = function(self,info_queue, center)
        return {vars = {}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra.amount)
            return true end }))
        delay(0.6)
    end,
	in_pool = function(self, args)
		return true
	end,
}

SMODS.Consumable{ -- $10
    key = 'ten', --key
    set = 'cash', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 2, y = 3}, --position in atlas
    loc_txt = {
        name = '10 Dollar Bill', --name of card
        text = { --text of card
            'Gain $10'
        }
    },
    config = {
        extra = {
		amount = 10
        }
    },
	cost = 10,
    loc_vars = function(self,info_queue, center)
        return {vars = {}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra.amount)
            return true end }))
        delay(0.6)
    end,
	in_pool = function(self, args)
		return true
	end,
}

SMODS.Consumable{ -- $20
    key = 'twentey', --key
    set = 'cash', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 3, y = 3}, --position in atlas
    loc_txt = {
        name = '20 Dollar Bill', --name of card
        text = { --text of card
            'Gain $20'
        }
    },
    config = {
        extra = {
		amount = 20
        }
    },
	cost = 20,
    loc_vars = function(self,info_queue, center)
        return {vars = {}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra.amount)
            return true end }))
        delay(0.6)
    end,
	in_pool = function(self, args)
		return true
	end,
}

SMODS.Consumable{ -- $50
    key = 'fifty', --key
    set = 'cash', --the set of the card: corresponds to a consumable type
    atlas = 'Jokers', --atlas
    pos = {x = 4, y = 3}, --position in atlas
    loc_txt = {
        name = '50 Dollar Bill', --name of card
        text = { --text of card
            'Gain $50'
        }
    },
    config = {
        extra = {
		amount = 50
        }
    },
	cost = 50,
    loc_vars = function(self,info_queue, center)
        return {vars = {}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(card.ability.extra.amount)
            return true end }))
        delay(0.6)
    end,
}


end

----------------------------------------------
------------MOD CODE END----------------------
    
