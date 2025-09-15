SMODS.Joker{ --Gluttony
    key = "gluttony",
    config = {
        extra = {
            xmult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Gluttony',
        ['text'] = {
            [1] = 'Always {C:legendary}Eternal{}',
            [2] = 'Gains {X:red,C:white}X0.2{} Mult when',
            [3] = 'a card is destroyed',
            [4] = 'Idea by {X:legendary,C:white}Ridry{}',
            [5] = '(Currently {X:red,C:white}X#1#{} Mult)'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.remove_playing_cards  then
                return {
                    func = function()
                    card.ability.extra.xmult = (card.ability.extra.xmult) + 0.2
                    return true
                end
                }
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmult
                }
        end
    end
}