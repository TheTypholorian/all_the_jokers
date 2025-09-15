SMODS.Joker{ --Ophidiophobia
    key = "ophidiophobia",
    config = {
        extra = {
            Xmult = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'Ophidiophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of snakes{}{}',
            [2] = '------------------------',
            [3] = 'Playing a {C:attention}Straight{} that',
            [4] = 'includes a {C:attention}6{} gains {X:red,C:white}X1.5{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (context.scoring_name == "Straight" and (function()
    local rankCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:get_id() == 6 then
            rankCount = rankCount + 1
        end
    end
    
    return rankCount >= 1
end)()) then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}