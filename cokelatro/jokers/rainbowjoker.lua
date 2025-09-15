SMODS.Joker{ --Rainbow Joker
    key = "rainbowjoker",
    config = {
        extra = {
            Balancing = 0
        }
    },
    loc_txt = {
        ['name'] = 'Rainbow Joker',
        ['text'] = {
            [1] = 'If {C:attention}played hand{} contains a card',
            [2] = 'with {C:red}Blen{}{C:blue}ding{} Enhancement and seal',
            [3] = 'balance {C:blue}Chips{} and {C:red}Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 15,
    rarity = "cokelatr_incredulous",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  and not context.blueprint then
            if ((function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_blending"] == true then
            count = count + 1
        end
    end
    return count >= 1
end)() and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if playing_card.seal == "cokelatr_blending" then
            count = count + 1
        end
    end
    return count >= 1
end)()) then
                return {
                    balance = true,
                    message = "Balanced!"
                }
            end
        end
    end
}