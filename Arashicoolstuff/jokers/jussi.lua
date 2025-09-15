SMODS.Joker{ --Jussi
    key = "jussi",
    config = {
        extra = {
            xmult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Jussi',
        ['text'] = {
            [1] = 'Gains {X:red,C:white}X0.5{} Mult when a {C:attention}card{}',
            [2] = 'is {C:attention}bought{}',
            [3] = '{C:inactive}(Currently {X:red,C:white}X#1#{} {C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["arashi_pet"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.buying_card  then
                return {
                    func = function()
                    card.ability.extra.xmult = (card.ability.extra.xmult) + 0.5
                    return true
                end
                }
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmult
                }
        end
    end
}