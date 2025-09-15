SMODS.Joker{ --Selenophobia
    key = "selenophobia",
    config = {
        extra = {
            chips = 20
        }
    },
    loc_txt = {
        ['name'] = 'Selenophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of the moon{}{}',
            [2] = '---------------------',
            [3] = 'Played {C:attention}Queens{} gain',
            [4] = '{C:blue}+20 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 3
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
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 12 then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}