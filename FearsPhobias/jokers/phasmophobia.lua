SMODS.Joker{ --Phasmophobia
    key = "phasmophobia",
    config = {
        extra = {
            xchips = 4
        }
    },
    loc_txt = {
        ['name'] = 'Phasmophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of ghosts.{}{}',
            [2] = '-------------------------',
            [3] = 'Playing a {C:attention}Flush{} with {C:spades}Spades{}',
            [4] = 'gains {X:blue,C:white}X4{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 2
    },
    cost = 15,
    rarity = 3,
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
        if not (c:is_suit("Spades")) then
            allMatchSuit = false
            break
        end
    end
    
    return allMatchSuit and #context.scoring_hand > 0
end)()) then
                return {
                    x_chips = card.ability.extra.xchips
                }
            end
        end
    end
}