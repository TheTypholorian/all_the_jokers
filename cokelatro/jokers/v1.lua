SMODS.Joker{ --MACHINEID V1
    key = "v1",
    config = {
        extra = {
            coins = 1,
            Sus = 0
        }
    },
    loc_txt = {
        ['name'] = 'MACHINEID V1',
        ['text'] = {
            [1] = 'Gains {X:red,C:white}X1{} Mult',
            [2] = 'if played hand contains',
            [3] = 'exactly four {C:money}Gold sealed{} cards',
            [4] = '{C:inactive}(currently{} {X:mult,C:white}X#1#{}{C:inactive} Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.coins}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if (#context.scoring_hand == 4 and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if playing_card.seal == "Gold" then
            count = count + 1
        end
    end
    return count == 4
end)()) then
                return {
                    func = function()
                    card.ability.extra.Sus = 1
                    return true
                end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.Sus
                }
        end
    end
}