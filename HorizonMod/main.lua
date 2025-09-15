	



--- common strings
local noperkeo  = '{C:inactive}(Cannot be copied by Perkeo)'

SMODS.Sound{
    key = 'hrzi_iamsniper',
    path = 'iamsniper.wav'
}

SMODS.Sound{
    key = 'hrzi_nowstart',
    path = 'nowstart.wav'
}

SMODS.Sound{
    key = 'hrzi_headshotea',
    path = 'headshotea.wav'
}

--- POKER HAND CODE

 --- Rampart
 SMODS.PokerHand{
    key = 'Rampart',
    visible = false,
    mult = 8,
    chips = 20,
    l_mult = 3,
    l_chips = 15,
    example = {
        {'m_stone', true, 'm_stone'},
        {'m_stone', true, 'm_stone'},
        {'m_stone', true, 'm_stone'},
        {'m_stone', true, 'm_stone'},
        {'m_stone', true, 'm_stone'},
    },
 

 
    evaluate = function(parts, hand)
        local stones = {}
        for i, card in ipairs(hand) do
            if card.ability and card.ability.name == 'Stone Card' or card.config.center_key == 'm_stone' then
                stones[#stones+1] = card
            end
        end
        return (#stones == 5) and {stones} or {}
    end,
 }
 
 
 
 
 --- HAND CODE END ---
 
 
 
 
 
 
 
 
 
 
 --- PLANET CODE ---

 
 --- Asteroid
 
 
    SMODS.Atlas{
        key = 'asteroid',
        path = 'asteroid.png',
        px = 71,
        py = 95,
 
 
    }
 
 
    SMODS.Consumable{
        object_type = "Consumable",
        set = "Planet",
        name = "asteroid",
        key = "asteroid",
        pos = { x = 0, y = 0 },
 

 
 
        config = { hand_type = 'hrzi_Rampart', softlock = true },
 
 
        cost = 3,
        atlas = "asteroid",
        order = 3,
        can_use = function(self, card)
            return true
        end,
        loc_vars = function(self, info_queue, center)           
           
            local levelone = G.GAME.hands["hrzi_Rampart"].level or 1
            local planetcolourone = G.C.HAND_LEVELS[math.min(levelone, 7)]
            if levelone == 1 then
                planetcolourone = G.C.UI.TEXT_DARK
            end
            return {
                vars = {
                    G.GAME.hands["hrzi_Rampart"].level,
                    G.GAME.hands["hrzi_Rampart"].l_mult,
                    G.GAME.hands["hrzi_Rampart"].l_chips,
                    colours = { planetcolourone },
                },
            }
        end,
    }
 
 
 
 
 --- PLANET CODE END ---
 
 
 
 
 --- CONSUMABLE CODE START ---
 --[[[SMODS.ConsumableType {
	key = 'hrzi_ability',
	collection_rows = {4, 4},
	primary_colour = G.C.CHIPS,
	secondary_colour = G.C.GREEN,
	loc_txt = {
		collection = 'Ability Cards',
		name = 'Ability Card'
	},
	shop_rate = 0
}

 SMODS.UndiscoveredSprite{
    key = 'hrzi_ability',
    atlas = 'test',
    pos = {x=0,y=0}
 }
 
 SMODS.Consumable{
    key = 'yin_c',
    loc_txt = {
        name = 'Yin',
        text = {
            'Lose {C:money}$5{}',
            '{C:blue}+1{} Hand',
            noperkeo
        }
    },
    set = 'hrzi_ability',
    cost = 0,
    no_perkeo = true,

    can_use = function(self, card)
        if not G.blind_select and G.STATE ~= G.STATES.ROUND_EVAL and not G.shop and not G.booster_pack then
            return true
        end
    end,
    use = function(self, card, area)
        ease_hands_played(1)
        ease_dollars(-5, true)
    end,
    keep_on_use = function(self, card)
        return true
    end
}

 
 SMODS.Consumable{
    key = 'yang_c',
    set = 'hrzi_ability',
    cost = 0,
    no_perkeo = true,
    loc_txt = {
        name = 'Yang',
        text = {
            'Lose {C:money}$5{}',
            '{C:red}+1{} Discard',
            noperkeo
        }
    },
    
    can_use = function(self, card)
        if not G.blind_select and G.STATE ~= G.STATES.ROUND_EVAL and not G.shop and not G.booster_pack then
            return true
        end
    end,

    use = function(self, card, area)
        ease_discard(1)
        ease_dollars(-5, true)
    end,

    keep_on_use = function(self, card)
        return true
    end
 }]]


--- JOKER CODE ---
SMODS.Joker:take_ownership('perkeo', {
    name = 'Perkeo',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {vars = {center.ability.extra}}
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            local valid_consumables = {}
            for _, c in ipairs(G.consumeables.cards) do
                local def = c.config.center
                if def and not def.no_perkeo then
                    table.insert(valid_consumables, c)
                end
            end

            if #valid_consumables > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local selected = pseudorandom_element(valid_consumables, pseudoseed('perkeo2'))
                        local duplicate = copy_card(selected, nil)
                        duplicate:set_edition('e_negative', true)
                        duplicate:add_to_deck()
                        G.consumeables:emplace(duplicate)
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                    { message = localize('k_duplicated_ex') })
            end
        end
    end
})



--[[[
--- Test Joker 
SMODS.Atlas{
    key = 'test',
    path = 'test.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'jtest',
    loc_txt = {
        name = 'Faggoty Waggoty',
        text = {
            '{X:mult,C:white}x#1#{} Mult',
            '{s:3}gay faggot gay gay :3 gay uwu{}',
            '{X:dark_edition,C:white}faggot{}',
            '{C:edition}Edition{}',
        },
    },

    atlas = 'test',
    pos = {x=0, y=0},
    rarity = 4,
    cost = 1,

    config = { 
        extra = {
            Xmult = 1.1e302
        }
    },

    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} 
    end,

    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end

        if context.setting_blind then
            local new_card = create_card('hrzi_ability', G.consumeables, nil, nil, nil, nil, 'yin_c')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card) 
        end
    end,

}
]]

--- Supreme Justice
SMODS.Atlas{
    key = 'supreme_justice',
    path = 'supreme_justice.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'supreme_justice',

    atlas = 'supreme_justice',
    pos = {x=0, y=0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_justice
        info_queue[#info_queue+1] = G.P_CENTERS.c_deja_vu
    end, 

    calculate = function(self, card, context)
        if context.first_hand_drawn and #G.consumeables.cards == 0 then
            -- Create Justice card
            local new_card = create_card('Justice', G.consumeables, nil, nil, nil, nil, 'c_justice')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

            -- Create Deja Vu card
            local new_card = create_card('Deja_Vu', G.consumeables, nil, nil, nil, nil, 'c_deja_vu')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

        end
    end, 
}


--- Skygazer
SMODS.Atlas{
    key = 'skygazer',
    path = 'skygazer.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'skygazer',

    atlas = 'skygazer',
    pos = {x=0, y=0},
    rarity = 4,
    cost = 10,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            odds = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = G.P_CENTERS.c_moon
        info_queue[#info_queue+1] = G.P_CENTERS.c_sun
        info_queue[#info_queue+1] = G.P_CENTERS.c_world
        info_queue[#info_queue+1] = G.P_CENTERS.c_star
        return {
            vars = {
                (G.GAME.probabilities.normal or 1),
                card.ability.extra.odds
            }
        }
    end, 

    calculate = function(self, card, context)
        if context.setting_blind and pseudorandom('skygaylmao') < G.GAME.probabilities.normal / card.ability.extra.odds then
            -- Create Moon card
            local new_card = create_card('Moon', G.consumeables, nil, nil, nil, nil, 'c_moon')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

            -- Create Sun card
            local new_card = create_card('Sun', G.consumeables, nil, nil, nil, nil, 'c_sun')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

            -- Create World card
            local new_card = create_card('World', G.consumeables, nil, nil, nil, nil, 'c_world')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

            -- Create Star card
            local new_card = create_card('Star', G.consumeables, nil, nil, nil, nil, 'c_star')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

        end
    end, 

}

--- Gacha
SMODS.Atlas{
    key = 'gacha',
    path = 'gacha.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'gacha',

    atlas = 'gacha',
    pos = {x=0, y=0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,


loc_vars = function(self, info_queue, card)
end,

calculate = function(self, card, context)
    if context.open_booster then 
        local money_pool = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,2,2,2,3,3,5,8,12,25}
        local amount = money_pool[math.random(#money_pool)]
        G.GAME.dollars = G.GAME.dollars + amount
        return{
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('timpani')
                ease_dollars(amount, true)
                return true end }))
        }
    end
end,
}


--- End Credits
SMODS.Atlas{
    key = 'end_credits',
    path = 'end_credits.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'end_credits',

    atlas = 'end_credits',
    pos = {x=0,y=0},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 0.25
        }
    },


    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            return {
                card = card,
                message = 'X' .. card.ability.extra.Xmult,
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end

}


--- Quarry
local money_added_tracker = {}

SMODS.Atlas{
    key = 'quarry',
    path = 'quarry.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'quarry',

    atlas = 'quarry',
    pos = {x=0,y=0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            money = 1
        }
    },

    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return { vars = {card.ability.extra.money}}
    end,

    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if SMODS.has_enhancement(context.other_card, 'm_stone') then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            play_sound('timpani')
                            ease_dollars(card.ability.extra.money, true)
                            return true
                        end,
                    }))
                    if not money_added_tracker[context.other_card] then
                        money_added_tracker[context.other_card] = true
                    end
                    return {
                        card = card,
                        message = 'Mined!',
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end,
}


--- Event Horizon
SMODS.Atlas{
    key = 'event_horizon',
    path = 'event_horizon.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'event_horizon',

    atlas = 'event_horizon',
    pos = {x=0,y=0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
    end, 


    calculate = function(self, card, context)
        if context.ending_shop then
            local planets_destroyed = 0
            for i = #G.consumeables.cards, 1, -1 do
                local c = G.consumeables.cards[i]
                if c.ability and c.ability.set == 'Planet' then
                    c:remove()
                    planets_destroyed = planets_destroyed + 1
                end
            end
            for i = 2, planets_destroyed do
                local new_card = create_card('Black Hole', G.consumeables, nil, nil, nil, nil, 'c_black_hole')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                return{
                    card = card,
                    message = 'Collapse!',
                    colour = G.C.PURPLE
                }
            end
        end
    end


}


--- To Apotheosis
SMODS.Atlas{
    key = 'to_apotheosis',
    path = 'to_apotheosis.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'to_apotheosis',

    atlas = 'to_apotheosis',
    pos = {x=0,y=0},
    soul_pos = {x = 1,y=0},
    rarity = 4,
    cost = 18,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 1.5
        }
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
    end,

calculate = function(self, card, context)
	if ((context.before and next(context.poker_hands['Five of a Kind'])) or  (context.before and next(context.poker_hands['Flush House'])) or (context.before and next(context.poker_hands['Flush Five'])) or (context.before and next(context.poker_hands['hrzi_Rampart']))) then
		card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
		return {
			message = 'Ascended',
			colour = G.C.MULT,
		}
	end
    

	if context.joker_main then
		return {
            card = card,
			Xmult_mod = card.ability.extra.Xmult,
            message = 'X' .. card.ability.extra.Xmult,
            colour = G.C.MULT,
		}
	end
end

}


--- Geologist 
SMODS.Atlas{
    key = 'geologist',
    path = 'geologist.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'geologist',
    loc_txt = {

    },

    atlas = 'geologist',
    pos = {x=0, y=0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return { vars = {card.ability.extra.mult} }
    end,


    calculate = function(self, card, context)
        local stone_count = 0
        for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_stone then 
                stone_count = stone_count + 1
            end
        end
        geo_mult = 3 * stone_count
        card.ability.extra.mult = geo_mult

        if context.joker_main and stone_count > 0 then
            return {
                card = card,
                mult_mod = card.ability.extra.mult,
                message = '+' .. card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end,
}


local stoneXchiptracker = {}

--- Stonehenge
SMODS.Atlas{
    key = 'stonehenge',
    path = 'stonehenge.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'stonehenge',


    atlas = 'stonehenge',
    pos = {x=0,y=0},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = {
        extra = {
            Xchips = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {vars = {card.ability.extra.Xchips}}
    end,

    reset = function(self)
        stoneXchiptracker = {}
    end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if SMODS.has_enhancement(context.other_card, 'm_stone') then
                    card.ability.extra.Xchips = card.ability.extra.Xchips + 0.5
                    if not stoneXchiptracker[context.other_card] then
                        stoneXchiptracker[context.other_card] = true
                    end
                    return {
                        card = card,
                        xchips = card.ability.extra.Xchips,
                        colour = G.C.CHIPS
                    }
                end
            end
        end

        if context.after and card.ability.extra.Xchips > 1 then
            card.ability.extra.Xchips = 1
            stoneXchiptracker = {}
            return {
                card = card,
                message = 'Reset!',
                colour = G.C.CHIPS
            }
        end
    end
}


local countdown = {}

--- Brainwashing
SMODS.Atlas{
    key = 'brainwashing',
    path = 'brainwashing.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'brainwashing',


    atlas = 'brainwashing',
    pos = {x = 0, y = 0},
    soul_pos = {x=1,y=0},
    rarity = 4,
    cost = 18,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    config = {
        extra = {
            Emult = 1.75,
            countdown = 3,
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return { vars = {card.ability.extra.Emult, card.ability.extra.countdown}}
    end,

    calculate = function(self, card, context)

        local contains_wild = false
        for _, played_card in ipairs(G.play.cards) do
            if SMODS.get_enhancements(played_card)["m_wild"] then
                contains_wild = true
                break  
            end
        end
    

        if context.after then
            if not contains_wild then
                card.ability.extra.countdown = card.ability.extra.countdown - 1
            end
            contains_wild = false
        end
    

        if card.ability.extra.countdown > 0 then
            if context.joker_main then
                return {
                    card = card,
                    Emult_mod = card.ability.extra.Emult,
                    message = '^' .. card.ability.extra.Emult,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    

        if card.ability.extra.countdown <= 0 and context.after then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                    return true
                end
            }))
        end
    end
   
}


--- Monopoly Man
SMODS.Atlas{
    key = 'wallstreet',
    path = 'wallstreet.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'monopoly_man',


    atlas = 'wallstreet',
    pos = {x = 0, y = 0},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,


    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    end,


    calculate = function(self, card, context)
        if context.discard and context.other_card then
            if not context.other_card.debuff and SMODS.get_enhancements(context.other_card)["m_gold"] then
                G.GAME.blind.chips = G.GAME.blind.chips * (0.85)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    card = card,
                    message = 'Reduced!',
                    colour = G.C.MONEY
                }
            end
        end
    end
}


--- Sinful Deal
SMODS.Atlas{
    key = 'sinful_deal',
    path = 'sinful_deal.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'sinful_deal',
    loc_txt = {
        name = 'Sinful Deal',
        text = {
            'When skipping a {C:attention}Booster Pack{}',
            'Create a {C:attention}Devil{} Tarot Card',
        }
    },

    atlas = 'sinful_deal',
    pos = {x = 0, y = 0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,   
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_devil
    end,

    calculate = function(self, card, context)

        if context.skipping_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then

            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            local new_card = create_card('Devil', G.consumeables, nil, nil, nil, nil, 'c_devil')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            G.GAME.consumeable_buffer = 0
        end
    end
}


--- Creme de la Crop
SMODS.Atlas{
    key = 'cremedlc',
    path = 'cremedlc.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'cremedlc',

    atlas = 'cremedlc',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,

    config = {
        extra = {
            cost = -12,
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return { vars = {card.ability.extra.cost}}
    end,

    calculate = function(self, card, context)
        local deduction = -12
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function() 
                        local card = create_card('Joker', G.jokers, nil, 0, nil, nil, nil, 'rif')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                    return true
                end}))   

                G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                    play_sound('timpani')
                    ease_dollars(card.ability.extra.cost, true)
                    return true end }))
                end
    end
}


---Headshot
SMODS.Atlas{
    key = 'headshot',
    path = 'headshot.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'headshot',

    atlas = 'headshot',
    pos = {x = 0, y = 0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,

    add_to_deck = function(self, card, debuff)
        play_sound("hrzi_iamsniper")
    end,

    calculate = function(self, card, context)
        if not G.blind_select and G.STATE ~= G.STATES.ROUND_EVAL and not G.shop and not G.booster_pack then
            if context.selling_card and context.card.config.center.set == "Joker" then
                G.GAME.blind.chips = G.GAME.blind.chips * 0.65
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                
                return {
                    card = card,
                    message = 'Headshot!',
                    colour = G.C.MULT,
                    play_sound("hrzi_headshotea")
                }
            end
        end

        if context.setting_blind then
            play_sound("hrzi_nowstart")
        end
        
    end
}

---YinYang
--[[[SMODS.Atlas{
    key = 'yinyang',
    path = 'yinyang.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'jyinyang',
    loc_txt = {
        name = 'Yin Yang',
        text = {
            'Create a {C:attention}Yin{} and {C:attention}Yang{}',
            '{C:inactive}(Gets destroyed if this joker is sold){}',
        }
    },

    atlas = 'yinyang',
    pos = {x=0,y=0},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,

    loc_vars = function(self, info_queue, center)

    end,

    calculate = function(self, card, context)
        
        local new_card = create_card('Yin', G.consumeables, nil, nil, nil, nil, 'c_yin')
        new_card:set_edition({negative = true}, true)
        new_card:add_to_deck()
        G.consumeables:emplace(new_card)

        local new_card = create_card('Yang', G.consumeables, nil, nil, nil, nil, 'c_yang')
        new_card:set_edition({negative = true}, true)
        new_card:add_to_deck()
        G.consumeables:emplace(new_card)
    end
}
]]


---The Chosen
SMODS.Atlas{
    key = 'thechosen',
    path = 'thechosen.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'thechosen',
    loc_txt = {

    },

    atlas = 'thechosen',
    pos = {x=0,y=0},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            Xmult = 6
        }
    },

    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.Xmult,
                localize(G.GAME.current_round.thechosen_card.suit, 'suits_singular'),
                colours = { G.C.SUITS[G.GAME.current_round.thechosen_card.suit] },
            }
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main then
            if #context.full_hand == 1 then
                local played_card = context.full_hand[1]
                if played_card:is_suit(G.GAME.current_round.thechosen_card.suit) and played_card:get_id() == 14 then
                    return {
                        card = card,
                        Xmult_mod = card.ability.extra.Xmult,
                        message = 'X'.. card.ability.extra.Xmult,
                        colour = G.C.MULT
                    }
                end
            end
        end

    end
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.thechosen_card = { suit = 'Spades' }
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.thechosen_card = { suit = 'Spades' }
	local valid_thechosen_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then 
			valid_thechosen_cards[#valid_thechosen_cards + 1] = v
		end
	end
	if valid_thechosen_cards[1] then
		local thechosen_card = pseudorandom_element(valid_thechosen_cards, pseudoseed('5tcs' .. G.GAME.round_resets.ante))
		G.GAME.current_round.thechosen_card.suit = thechosen_card.base.suit
	end
end

-- ]]
