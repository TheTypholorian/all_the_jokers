SMODS.Joker{ --Suspicious joker
    key = "suspiciousjoker",
    config = {
        extra = {
            Xmultvar = 1
        }
    },
    loc_txt = {
        ['name'] = 'Suspicious joker',
        ['text'] = {
            [1] = 'Gains {X:red,C:white}X0.1{} Mult per{C:attention} king{} scored',
            [2] = 'Gains additional {X:red,C:white}X0.2{} if it is a {C:attention}king{} of {C:hearts}hearts{}',
            [3] = '{C:inactive}(currently{} {X:red,C:white}X#1#{} {C:inactive}mult){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 8
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmultvar}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  and not context.blueprint then
            if context.other_card:get_id() == 13 then
                card.ability.extra.Xmultvar = (card.ability.extra.Xmultvar) + 0.1
                return {
                    message = "Upgrade!"
                }
            elseif (context.other_card:get_id() == 13 and context.other_card:is_suit("Hearts")) then
                card.ability.extra.Xmultvar = (card.ability.extra.Xmultvar) + 0.2
                return {
                    message = "Upgrade!"
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.Xmultvar
                }
        end
    end
}