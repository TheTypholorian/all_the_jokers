SMODS.Joker{ --Gamerxgd
    key = "gamerxgd",
    config = {
        extra = {
            repetitions = 1,
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Gamerxgd',
        ['text'] = {
            [1] = '{C:attention}Steel{} cards give {X:red,C:white}X2{} Mult, retrigger the played {C:attention}Lucky{} cards'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 6,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play  then
            if (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_lucky"] == true then
            count = count + 1
        end
    end
    return count == 1
end)() then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex')
                }
            end
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round  then
            if SMODS.get_enhancements(context.other_card)["m_steel"] == true then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}