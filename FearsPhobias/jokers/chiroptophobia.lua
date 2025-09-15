SMODS.Joker{ --Chiroptophobia
    key = "chiroptophobia",
    config = {
        extra = {
            chips = 25
        }
    },
    loc_txt = {
        ['name'] = 'Chiroptophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of bats{}{}',
            [2] = '-----------------------',
            [3] = 'If a {C:attention}Flush{} contains {C:clubs}Clubs{},',
            [4] = '{C:blue}+25 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 1
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
        if context.cardarea == G.jokers and context.joker_main  then
            if (context.scoring_name == "Flush" and (function()
    local allMatchSuit = true
    for i, c in ipairs(context.scoring_hand) do
        if not (c:is_suit("Clubs")) then
            allMatchSuit = false
            break
        end
    end
    
    return allMatchSuit and #context.scoring_hand > 0
end)()) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}