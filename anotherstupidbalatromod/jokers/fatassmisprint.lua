SMODS.Joker{ 
    key = "fatassmisprint",
    config = {
        extra = {
            Xmult_min = 1,
            Xmult_max = 25,
            odds = 15,
            var1 = 0,
            shit_food = 0
        }
    },
    loc_txt = {
        ['name'] = 'Fatass Misprint',
        ['text'] = {
            [1] = '{C:green}#3# in #4# chance{} to eat all other Jokers'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = { x = 7, y = 6 },
    display_size = { w = 71 * 1, h = 95 * 1 },
    cost = 6,
    rarity = "shit_shitpost",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local r_xmults = {}
        for i = card.ability.extra.Xmult_min, card.ability.extra.Xmult_max do
            r_xmults[#r_xmults + 1] = "X" .. tostring(i)
        end
        
        local loc_mult = ' ' .. (localize('k_mult')) .. ' '
        
        main_start = {
            { 
                n = G.UIT.O, 
                config = { 
                    object = DynaText({ 
                        string = r_xmults, 
                        colours = { G.C.RED }, 
                        pop_in_rate = 9999999, 
                        silent = true, 
                        random_element = true, 
                        pop_delay = 0.5, 
                        scale = 0.4, 
                        min_cycle_time = 0 
                    }) 
                } 
            }
        }
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_shit_fatassmisprint') 
        return {
            main_start = main_start,
            vars = {card.ability.extra.shit_food, card.ability.extra.var1, new_numerator, new_denominator}
        }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                Xmult = pseudorandom('Xmult_3e78fd75', card.ability.extra.Xmult_min, card.ability.extra.Xmult_max),
                func = function()
                    if SMODS.pseudorandom_probability(card, 'group_0_21e8e906', 1, card.ability.extra.odds, 'j_shit_fatassmisprint', false) then
                        local jokers_destroyed = 0
                        for i = #G.jokers.cards, 1, -1 do
                            local joker = G.jokers.cards[i]
                            if joker ~= card and not joker.ability.eternal and not joker.getting_sliced then
                                joker.getting_sliced = true
                                jokers_destroyed = jokers_destroyed + 1
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        joker:start_dissolve({G.C.RED}, nil, 1.6)
                                        return true
                                    end
                                }))
                            end
                        end
                        
                        if jokers_destroyed > 0 then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Nom nom nom!", colour = G.C.RED})
                            play_sound("shit_food")
                        end
                    end
                    return true
                end
            }
        end
    end
}