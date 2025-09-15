SMODS.Joker{ --Einstonio
    key = "einstonio",
    config = {
        extra = {
            xmultvar = 1
        }
    },
    loc_txt = {
        ['name'] = 'Einstonio',
        ['text'] = {
            [1] = 'This Joker gains {X:red,C:white}X0.1{} Mult',
            [2] = 'every time a {C:purple}Generic{} card is used',
            [3] = '{C:inactive}(Currently {X:red,C:white}X#1#{} {C:inactive}Mult){}{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 6
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

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmultvar}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable  then
            if context.consumeable and (context.consumeable.ability.set == 'generic' or context.consumeable.ability.set == 'generic') then
                return {
                    func = function()
                    card.ability.extra.xmultvar = (card.ability.extra.xmultvar) + 0.1
                    return true
                end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmultvar
                }
        end
    end
}