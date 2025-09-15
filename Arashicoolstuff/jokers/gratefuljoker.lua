SMODS.Joker{ --Grateful Joker
    key = "gratefuljoker",
    config = {
        extra = {
            rerolls = 0,
            xmult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Grateful Joker',
        ['text'] = {
            [1] = 'Gains {X:red,C:white}X2{} Mult when shop',
            [2] = 'is exited without using any rerolls',
            [3] = 'Loses {X:red,C:white}X1.5{} Mult per reroll',
            [4] = '(Currently {X:red,C:white}X#2#{} Mult)'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rerolls, card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.reroll_shop  then
                return {
                    func = function()
                    card.ability.extra.rerolls = (card.ability.extra.rerolls) + 1
                    return true
                end,
                    extra = {
                        func = function()
                    card.ability.extra.xmult = math.max(0, (card.ability.extra.xmult) - 1.5)
                    return true
                end,
                        colour = G.C.RED
                        }
                }
        end
        if context.ending_shop  then
            if (card.ability.extra.rerolls or 0) == 0 then
                return {
                    func = function()
                    card.ability.extra.xmult = (card.ability.extra.xmult) + 2
                    return true
                end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmult
                }
        end
    end
}