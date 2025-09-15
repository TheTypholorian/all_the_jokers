SMODS.Joker{ --The Pride
    key = "thepride",
    config = {
        extra = {
            VARR = 0.98,
            Visual = 2
        }
    },
    loc_txt = {
        ['name'] = 'The Pride',
        ['text'] = {
            [1] = 'Scored {C:attention}Wild cards{} decrease the {C:red}blind{}',
            [2] = 'requirement by {C:attention}#2#%{}, Increases by {C:attention}2%{} per Ante'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 500,
    rarity = "cokelatr_almanetic",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 7,
        y = 9
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.VARR, card.ability.extra.Visual}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_wild"] == true then
                return {
                    func = function()
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "X"..tostring(card.ability.extra.VARR).." Blind Size", colour = G.C.GREEN})
                G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.VARR
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.HUD_blind:recalculate()
                return true
            end
                }
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  and not context.blueprint then
                return {
                    func = function()
                    card.ability.extra.VARR = math.max(0, (card.ability.extra.VARR) - 0.02)
                    return true
                end,
                    extra = {
                        func = function()
                    card.ability.extra.Visual = (card.ability.extra.Visual) + 2
                    return true
                end,
                        colour = G.C.GREEN
                        }
                }
        end
    end
}