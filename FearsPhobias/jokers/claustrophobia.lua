SMODS.Joker{ --Claustrophobia
    key = "claustrophobia",
    config = {
        extra = {
            xchips = 1.2
        }
    },
    loc_txt = {
        ['name'] = 'Claustrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of confined spaces{}',
            [2] = '--------------------------',
            [3] = '{}{C:attention}Three of a Kind{} gives',
            [4] = '{X:blue,C:white}X1.2{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Three of a Kind" then
                return {
                    x_chips = card.ability.extra.xchips
                }
            end
        end
    end
}