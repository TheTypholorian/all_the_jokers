SMODS.Joker{ --Catoptrophobia
    key = "catoptrophobia",
    config = {
        extra = {
            xchips = 2,
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Catoptrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of mirrors.{}{}',
            [2] = '----------------------',
            [3] = 'When any hand is played,',
            [4] = '{X:red,C:white}^2{} {C:red}Mult{} and {X:blue,C:white}^2{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    cost = 12,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 1,
        y = 1
    },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    x_chips = card.ability.extra.xchips,
                    extra = {
                        Xmult = card.ability.extra.Xmult
                        }
                }
        end
    end
}