SMODS.Joker{ --Astrophobia
    key = "astrophobia",
    config = {
        extra = {
            xchips = 1.5,
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Astrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of space{}{}',
            [2] = '---------------------------',
            [3] = 'When a {C:attention}Straight{} is played,',
            [4] = 'gain {X:blue,C:white}^1.5{} {C:blue}Chips{} and {X:red,C:white}^2{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 7,
        y = 0
    },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Straight" then
                return {
                    x_chips = card.ability.extra.xchips,
                    extra = {
                        Xmult = card.ability.extra.Xmult
                        }
                }
            end
        end
    end
}