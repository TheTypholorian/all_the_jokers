SMODS.Joker{ --Hemophobia
    key = "hemophobia",
    config = {
        extra = {
            mult = 15
        }
    },
    loc_txt = {
        ['name'] = 'Hemophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of blood{}{}',
            [2] = '---------------------------',
            [3] = 'When the played hand {C:attention}doesn\'t{}',
            [4] = 'contain {C:hearts}Hearts{}, gain +15 Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 2
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
            if not ((function()
    local allMatchSuit = true
    for i, c in ipairs(context.scoring_hand) do
        if not (c:is_suit("Hearts")) then
            allMatchSuit = false
            break
        end
    end
    
    return allMatchSuit and #context.scoring_hand > 0
end)()) then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}