SMODS.Joker{ --Crimson Joker
    key = "suit2",
    config = {
        extra = {
            mult = 3
        }
    },
    loc_txt = {
        ['name'] = 'Crimson Joker',
        ['text'] = {
            [1] = 'Played cards with {C:red}Red{} suit give {C:mult}+3{} Mult when scored',
            [2] = '{C:inactive}({C:hearts}Hearts{} {C:inactive}and{} {C:diamonds}Diamonds{}{C:inactive}){}{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}