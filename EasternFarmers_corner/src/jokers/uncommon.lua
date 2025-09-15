SMODS.Joker{
    --[[
    Rework to my d100 idea. Rolls the d100, below 50 it subtracts that from mult,
    above 50 adds it to mult, but if you hit 50 exactly it does times 50 to mult instead
    ]]
    key = "gamblersdream", -- Idea Credit: wimpyzombie22 @ discord
    loc_txt = {
        name = 'Gamblers dream',
        text = {
            'Rolls the {C:gold}d100{},',
            'if the result is {C:gold}below 50{} it subtracts it from mult,',
            'if the result is {C:gold}above 50{} adds it to mult,',
            'if the result is {C:gold}exactly 50{} it applies {X:mult,C:white}X#1#{} to mult instead'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult_for_hit_50} }
    end,
    config = { extra = {Xmult_for_hit_50 = 50, FPS = 6, delay = 0, x_pos = 0} },
    atlas = "LetsGoGambling",
    pos = {x=0, y=0},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    demicoloncompat = true,
    rarity = 2,
    cost = 6,
    update = function(self, card, dt)
        if card.ability.extra.delay == 60 / card.ability.extra.FPS then
            card.ability.extra.x_pos = (card.ability.extra.x_pos + 1) % 40
            card.children.center:set_sprite_pos({x=card.ability.extra.x_pos,y=0})
            card.ability.extra.delay = 0
        else
            card.ability.extra.delay = card.ability.extra.delay + 1
        end
    end,

    add_to_deck = function (self, card, dt)
        play_sound("EF_LetsGoGamblingSound", 1, 1)
    end,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: wimpyzombie22', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.forcetrigger or (context.joker_main and card.ability.cry_rigged) then -- cryptid compat
            return { xmult = card.ability.extra.Xmult_for_hit_50}
        elseif context.joker_main then
            local random_num = pseudorandom('GamblersDream', 1, 100)
            if 1 <= random_num and random_num < 50 then
                return {
                    mult = -random_num
                }
            elseif random_num == 50 then
                return {
                    xmult = card.ability.extra.Xmult_for_hit_50
                }
            elseif 50 < random_num and random_num <= 100 then
                return {
                    mult = random_num
                }
            else
                sendErrorMessage("result not in range 1 - 100 (somehow). random_num = "..random_num, "GamblersDream")
            end 
        end
    end
}

SMODS.Joker {
    key = "fertilizer",
    loc_txt = {
        name = 'Fertilizer',
        text = {
            '{C:ef_plant}Plant{} Jokers give',
            '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult.',
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    joker_display_def = function (JokerDisplay)
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
                { text = "x" },
                { text = "Plant", colour = G.C.EF.PLANT },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                if G.jokers then
                    for _, joker_card in ipairs(G.jokers.cards) do
                        if joker_card.config.center.rarity and joker_card.config.center.rarity == "EF_plant" then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.count = count
            end,
            mod_function = function(card, mod_joker)
                return {
                    mult = (card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.mult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                    chips = (card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.chips * JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                }
            end
        }
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "Jokers",
    pos = {x=9,y=0},
    config = { extra = { chips = 20, mult = 20 } },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == "EF_plant" then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end,
}

SMODS.Joker {
    key = "photosynthesis",
    loc_txt = {
        name = 'Photosynthesis',
        text = {
            'If your computer time is',
            'between {C:gold}#1#{} and {C:gold}#2#{} {C:ef_plant}Plant{} jokers',
            'each give {X:mult,C:white}X#3#{} Mult'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {EF.normal_hour_to_am_pm(card.ability.immutable.min_hour), EF.normal_hour_to_am_pm(card.ability.immutable.max_hour), card.ability.extra.xmult}}
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                {ref_table = "card.joker_display_values", ref_value = "effective", colour = G.C.GOLD},
                {text = " Plant", colour = G.C.EF.PLANT},
                {text = " jokers"}
            },
            calc_function = function(card)
                local count = 0
                if G.jokers then
                    for _, joker_card in ipairs(G.jokers.cards) do
                        if joker_card.config.center.rarity and joker_card.config.center.rarity == "EF_plant" then
                            count = count + 1
                        end
                    end
                end

                if count == 0 or EF.hour_check(card) then
                    card.joker_display_values.effective = count
                else
                    card.joker_display_values.effective = "Effective 0"
                end
            end,
            mod_function = function(card, mod_joker)
                return {
                    x_mult = (EF.hour_check(mod_joker) and card.config.center.rarity == "EF_plant" and mod_joker.ability.extra.xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil),
                }
            end
        }
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "Jokers",
    pos = {x=6,y=1},
    config = { extra = {xmult = 2}, immutable = { min_hour = 8, max_hour = 20} },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == "EF_plant" then
            if EF.hour_check(card) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end 
        end
    end,
}

SMODS.Joker {
    key = "9-5",
    loc_txt = {
        name = '9-5',
        text = {
            'If your computer time is',
            'between {C:gold}#1#{} and {C:gold}#2#{} {X:mult,C:white}X#3#{} Mult',
            'and {C:money}#4#${} at the end of the round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
            EF.normal_hour_to_am_pm(card.ability.immutable.min_hour),
            EF.normal_hour_to_am_pm(card.ability.immutable.max_hour),
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            }
        }
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                    }
                },
                { text = "+$", colour = G.C.MONEY },
                {ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY},
            },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_text" },
            },
            calc_function = function(card)
                if EF.hour_check(card) then
                    card.joker_display_values.xmult = card.ability.extra.xmult
                    card.joker_display_values.dollars = card.ability.extra.dollars
                    card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
                else
                    card.joker_display_values.xmult = 1
                    card.joker_display_values.dollars = 0
                    card.joker_display_values.localized_text = ""
                end
            end
        }
    end,
    config = { extra = {xmult = 0.5, dollars = 10}, immutable = { min_hour = 9, max_hour = 17} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2, -- dunno if change needed
    cost = 6,
    atlas = "Jokers",
    pos = {x=0,y=1},
    calculate = function(self, card, context)
        if EF.hour_check(card) then
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if EF.hour_check(card) then
            return card.ability.extra.dollars
        end
    end
}

SMODS.Joker {
    key = "gardengnome",
    loc_txt = {
        name = 'Garden Gnome',
        text = {
            'Add {C:money}$#1#{} of {C:attention}sell value{}',
            'to every {C:ef_plant}Plant{} jokers',
            'at end of the round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.sell_value} }
    end,
    config = { extra = {sell_value = 2} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = "Jokers",
    pos = {x=5,y=1},
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            for _, other_card in ipairs(G.jokers.cards) do
                if other_card.set_cost and other_card.config.center.rarity == "EF_plant" then
                    other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                        card.ability.extra.sell_value
                    other_card:set_cost()
                end
            end
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end,
    set_badges = function (self, card, badges)
        badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
        badges[#badges+1] = create_badge('Art Credit: diamondsapphire', G.C.EF.ART_CREDIT, G.C.BLACK, 0.8 )
    end
}
