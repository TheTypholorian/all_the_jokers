SMODS.Joker{ --Pluviophobia
    key = "pluviophobia",
    config = {
        extra = {
            chips = 6
        }
    },
    loc_txt = {
        ['name'] = 'Pluviophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of rain{}{}',
            [2] = '---------------------',
            [3] = '{C:diamonds}Diamonds{} give {C:blue}+6 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 3
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
            if context.other_card:is_suit("Diamonds") then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}