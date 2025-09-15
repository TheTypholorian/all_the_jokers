SMODS.Joker{ --Big Joker
    key = "bigjoker",
    config = {
        extra = {
            xchips = 1
        }
    },
    loc_txt = {
        ['name'] = 'Big Joker',
        ['text'] = {
            [1] = 'When an {C:attention}ace is scored{}, gain',
            [2] = '{X:chips,C:white}X0.1{} {C:blue}chips{}',
            [3] = '{C:inactive}(Currently {}{X:chips,C:white}X#1#{} {C:inactive}chips){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    display_size = {
        w = 71 * 1.3, 
        h = 95 * 1.3
    },
    cost = 4,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xchips}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 14 then
                card.ability.extra.xchips = (card.ability.extra.xchips) + 0.1
                return {
                    message = "Grow!"
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    x_chips = card.ability.extra.xchips
                }
        end
    end
}