SMODS.Joker{ --Cacophobia
    key = "cacophobia",
    config = {
        extra = {
            chips = 25
        }
    },
    loc_txt = {
        ['name'] = 'Cacophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of ugliness{}{}',
            [2] = '--------------------------',
            [3] = 'If the played hand contains',
            [4] = '{C:attention}odd{} numbers, gain {C:blue}+25 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (context.other_card:get_id() == 14 or context.other_card:get_id() == 3 or context.other_card:get_id() == 5 or context.other_card:get_id() == 7 or context.other_card:get_id() == 9) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}