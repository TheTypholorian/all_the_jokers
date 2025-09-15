SMODS.Joker{ --Thalassophobia
    key = "thalassophobia",
    config = {
        extra = {
            chips = 5,
            chips2 = -5
        }
    },
    loc_txt = {
        ['name'] = 'Thalassophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of the ocean.{}{}',
            [2] = '---------------------',
            [3] = '{C:hearts}Hearts{} gain {C:blue}+5 Chips{}',
            [4] = '{C:clubs}Clubs{} subtract {C:blue}-5 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 3
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Hearts") then
                return {
                    chips = card.ability.extra.chips
                }
            elseif context.other_card:is_suit("Clubs") then
                return {
                    chips = card.ability.extra.chips2
                }
            end
        end
    end
}