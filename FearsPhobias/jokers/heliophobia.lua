SMODS.Joker{ --Heliophobia
    key = "heliophobia",
    config = {
        extra = {
            xchips = 2
        }
    },
    loc_txt = {
        ['name'] = 'Heliophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of light{}{}',
            [2] = '---------------------',
            [3] = '{C:diamonds}Diamonds{} give {X:blue,C:white}X2{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 1
    },
    cost = 20,
    rarity = 4,
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
                    x_chips = card.ability.extra.xchips
                }
            end
        end
    end
}