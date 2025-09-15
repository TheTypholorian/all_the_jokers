SMODS.Joker{ --Anthophobia
    key = "anthophobia",
    config = {
        extra = {
            chips = 15
        }
    },
    loc_txt = {
        ['name'] = 'Anthophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of flowers{}{}',
            [2] = '---------------------',
            [3] = '{C:hearts}Hearts{} give {C:blue}+15 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 3,
        y = 0
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Hearts") then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}