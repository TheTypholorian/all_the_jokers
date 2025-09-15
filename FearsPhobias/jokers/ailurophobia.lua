SMODS.Joker{ --Ailurophobia
    key = "ailurophobia",
    config = {
        extra = {
            chips = 50
        }
    },
    loc_txt = {
        ['name'] = 'Ailurophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of cats{}{}',
            [2] = '------------------------',
            [3] = 'If {C:attention}no Queens{} are in the',
            [4] = 'played hand, gain {C:blue}+50 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
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
            if (function()
    local rankFound = true
    for i, c in ipairs(context.scoring_hand) do
        if c:get_id() == 12 then
            rankFound = false
            break
        end
    end
    
    return rankFound
end)() then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}