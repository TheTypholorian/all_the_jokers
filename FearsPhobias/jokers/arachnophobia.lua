SMODS.Joker{ --Arachnophobia
    key = "arachnophobia",
    config = {
        extra = {
            chips = 25
        }
    },
    loc_txt = {
        ['name'] = 'Arachnophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of spiders{}{}',
            [2] = '---------------------',
            [3] = 'Playing a {C:attention}3{} or {C:attention}8{}',
            [4] = 'gives {C:blue}+25 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
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
    soul_pos = {
        x = 5,
        y = 0
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (context.other_card:get_id() == 3 or context.other_card:get_id() == 8) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}