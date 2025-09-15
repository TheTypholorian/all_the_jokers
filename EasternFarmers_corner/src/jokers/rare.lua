SMODS.Joker{
    --[[
    "Everytime Wheel of Fortune misses, it randomly upgrades one of the hands"
    ]]
    key = "spacewheel", -- Idea Credit: alperen_pro @ discord
    loc_txt = {
        name = 'Wheel of Space',
        text = {
            'Everytime {C:tarot}Wheel of Fortune{}',
            'misses, it upgrades the most',
            'played {C:gold}Poker Hand{}',
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "c_wheel_of_fortune", set="Tarot"}
        return {}
    end,
    config = { extra = {} },
    atlas = "Jokers",
    pos = {x = 4, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    demicoloncompat = true, immutable = true, --cryptid
    rarity = 3,
    cost = 8,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: alperen_pro', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
        if context.blueprint then
            return
        end
        if context.forcetrigger or context.pseudorandom_result and not context.result and context.identifier == "wheel_of_fortune" then
            local hand_chosen = EF.get_most_played_hands()[1].key
            SMODS.calculate_effect({message = "Level up!"}, card)
            SMODS.smart_level_up_hand(nil, hand_chosen, false)
        end
    end
}

SMODS.Joker{
    --[[
    oh i got an idea if ur interested, joker that re-triggers plant jokers x times, 
    increased by 1 everytime u beat the plant or water boss blind and uh called good harvest? --._.fr
    ]]
    key = "goodharvest", -- Idea Credit: alperen_pro @ discord
    loc_txt = {
        name = 'Good Harvest',
        text = {
            'Retriggers {C:ef_plant}Plant{} jokers #1# times',
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retriggers}}
    end,
    joker_display_def =function (JokerDisplay)
        return {
            retrigger_joker_function = function (card, retrigger_joker)
                if card ~= retrigger_joker and card.config.center.rarity == "EF_plant" then
                    return retrigger_joker.ability.extra.retriggers
                end
            end
        }
    end,
    config = { extra = {retriggers = 1} },
    atlas = "Jokers",
    pos = {x = 8, y = 0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    rarity = 3,
    cost = 8,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: ._.fr', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and not context.blueprint then
            if context.other_card.config.center.rarity == "EF_plant" then
                return {repetitions = card.ability.extra.retriggers}
            end
        end
	end,
}

SMODS.Joker {
    key = "thatsodd",
    loc_txt = {
        name = 'That\'s odd',
        text = {
            '{X:mult,C:white}X#1#{} Mult on even minutes,',
            '{X:mult,C:white}X#2#{} Mult on odd minutes'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            card.ability.extra.good_xmult,
            card.ability.extra.bad_xmult,
        }
    }
    end,
    ---@param JokerDisplay JokerDisplay
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local num = EF.get_time_table().min
                if num % 2 == 1 then -- odd
                    card.joker_display_values.x_mult = card.ability.extra.bad_xmult
                else -- even
                    card.joker_display_values.x_mult = card.ability.extra.good_xmult
                end
            end
        }
    end,
    config = { extra = {good_xmult = 8, bad_xmult = 2} },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 3, -- dunno if change needed
    cost = 8,
    atlas = "Jokers",
    pos = {x=7,y=1},
    calculate = function(self, card, context)
        if context.joker_main then
            local num = EF.get_time_table().min
            if num % 2 == 1 then -- odd
                return {
                    xmult = card.ability.extra.bad_xmult
                }
            else -- even
                return {
                    xmult = card.ability.extra.good_xmult
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "rootofevil",
    loc_txt = {
        name = 'The Root of all evil',
        text = {
            'All played {C:gold}number{} cards',
            'become {C:gold}Root{} cards',
            'when scored.',
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_EF_root
        return { vars = {  } }
    end,
    config = { extra = {  } },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    atlas = "missing_joker",
    --pos = {x=9,y=0},
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local number = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if not scored_card:is_face() and scored_card:get_id() ~= 14 then
                    number = number + 1
                    scored_card:set_ability('m_EF_root', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            
            if number > 0 then
                return {
                    message = "Rooted",
                    colour = G.C.MONEY
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "enhancedsoil",
    loc_txt = {
        name = 'Enhanced Soil',
        text = {
            'Retriggers all {C:gold}Root{} cards {C:gold}#1#{} time'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_EF_root
        return { vars = { card.ability.extra.retrigger } }
    end,
    joker_display_def = function (JokerDisplay)
        return {
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                return playing_card and SMODS.has_enhancement(playing_card, 'm_EF_root') and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        }
    end,
    config = { extra = { retrigger = 1 } },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    atlas = "missing_joker",
    --pos = {x=9,y=0},
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_EF_root') then
            return {
                repetitions = card.ability.extra.retrigger
            }
        end
    end,
}

SMODS.Joker {
    key = "e",
    loc_txt = {
        name = 'E',
        text = {
            'Cards that have the letter E in',
            'their name are retriggered',
            '{s:0.8,C:inactive}(eg. Queen, Ten, Joker){}'

        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    config = { extra = { retrigger = 1 } },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 3,
    cost = 10,
    atlas = "Jokers",
    pos = {x=8,y=1},
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: alperen_pro', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    calculate = function(self, card, context)
        if context.blueprint then
            return
        end
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card then
            local name = string.gsub(context.other_card.config.center.name, "j_.+_", "", 1)
            if name ~= "e" then
                if string.match(name, "E") or string.match(name, "e") then
                    return {repetitions = card.ability.extra.retrigger}
                end
            end
        end
        if context.repetition and context.cardarea == G.play then
            local check = { [2]=false, [3] = true, [4] = false, [5] = true, [6] = false,
                [7] = true, [8] = true, [9] = true, [10] = true, [11] = false, [12] = true, [13] = false, [14] = true}
            if check[context.other_card.base.id] then
                return {repetitions = card.ability.extra.retrigger}
            end
        end
    end,
}