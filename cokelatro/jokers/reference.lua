SMODS.Joker{ --Jokehub
    key = "reference",
    config = {
        extra = {
            mult = 69,
            mult2 = 69
        }
    },
    loc_txt = {
        ['name'] = 'Jokehub',
        ['text'] = {
            [1] = '{C:red}+69{} Mult if played {C:attention}hand{} has',
            [2] = '3 {C:diamonds}Diamonds{} or 2 spades',
            [3] = '{C:red}+420{} mult if played {C:attention}hand{} has',
            [4] = '3 {C:diamonds}diamonds{} AND 2 spades'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if ((function()
    local suitCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:is_suit("Diamonds") then
            suitCount = suitCount + 1
        end
    end
    
    return suitCount == 3
end)() and (function()
    local suitCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:is_suit("Spades") then
            suitCount = suitCount + 1
        end
    end
    
    return suitCount == 2
end)()) then
                return {
                    mult = card.ability.extra.mult,
                    message = "FUNNY NUMBER!"
                }
            elseif ((function()
    local suitCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:is_suit("Diamonds") then
            suitCount = suitCount + 1
        end
    end
    
    return suitCount == 3
end)() or (function()
    local suitCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:is_suit("Spades") then
            suitCount = suitCount + 1
        end
    end
    
    return suitCount == 2
end)()) then
                return {
                    mult = card.ability.extra.mult2,
                    message = "FUNNY NUMBER!"
                }
            end
        end
    end
}