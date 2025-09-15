SMODS.Joker{ --Error 404
    key = "error404",
    config = {
        extra = {
            chips = 404,
            mult = 404
        }
    },
    loc_txt = {
        ['name'] = 'Error 404',
        ['text'] = {
            [1] = '{C:red}+404{} Mult {C:blue}+404{} Chips'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    message = "Error 404",
                    extra = {
                        chips = card.ability.extra.chips,
                        colour = G.C.CHIPS,
                        extra = {
                            mult = card.ability.extra.mult
                        }
                        }
                }
        end
    end
}