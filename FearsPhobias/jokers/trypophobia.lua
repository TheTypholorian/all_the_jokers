SMODS.Joker{ --Trypophobia
    key = "trypophobia",
    config = {
        extra = {
            chips = 25
        }
    },
    loc_txt = {
        ['name'] = 'Trypophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of repeated',
            [2] = 'patterns or holes.{}{}',
            [3] = '----------------------------',
            [4] = 'If played hand contains',
            [5] = '{C:attention}Three of a Kind{}, gain {C:blue}+25 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 3
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
            if next(context.poker_hands["Three of a Kind"]) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}