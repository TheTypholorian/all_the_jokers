SMODS.Joker{ --Technophobia
    key = "technophobia",
    config = {
        extra = {
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Technophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of technology{}{}',
            [2] = '--------------------------',
            [3] = 'If no {C:enhanced}Enhanced{} cards are in',
            [4] = 'play, gain {X:red,C:white}X2{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 3
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if next(SMODS.get_enhancements(playing_card)) then
            count = count + 1
        end
    end
    return count < 1
end)() then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}