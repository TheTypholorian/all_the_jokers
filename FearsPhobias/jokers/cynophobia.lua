SMODS.Joker{ --Cynophobia
    key = "cynophobia",
    config = {
        extra = {
            Xmult = 1.25
        }
    },
    loc_txt = {
        ['name'] = 'Cynophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of dogs{}{}',
            [2] = '--------------------------------',
            [3] = 'When the hand played',
            [4] = 'is {C:attention}only{} Face cards,',
            [5] = 'gain {X:red,C:white}X1.25{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 1
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
    local allMatchRank = true
    for i, c in ipairs(context.scoring_hand) do
        if not (c:is_face()) then
            allMatchRank = false
            break
        end
    end
    
    return allMatchRank and #context.scoring_hand > 0
end)() then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}