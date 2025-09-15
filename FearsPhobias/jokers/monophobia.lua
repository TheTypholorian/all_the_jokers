SMODS.Joker{ --Monophobia
    key = "monophobia",
    config = {
        extra = {
            chips = 20
        }
    },
    loc_txt = {
        ['name'] = 'Monophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of being alone{}{}',
            [2] = '---------------------------',
            [3] = 'If the played hand contains',
            [4] = 'a {C:attention}Flush{}, gain {C:blue}+20 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if next(context.poker_hands["Flush"]) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}