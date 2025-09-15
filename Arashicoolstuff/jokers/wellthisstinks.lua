SMODS.Joker{ --Well this stinks
    key = "wellthisstinks",
    config = {
        extra = {
            Xmult = 5
        }
    },
    loc_txt = {
        ['name'] = 'Well this stinks',
        ['text'] = {
            [1] = '{X:red,C:white}X5{} Mult',
            [2] = 'Is destroyed when a playing card is destroyed'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 3
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

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.Xmult
                }
        end
        if context.remove_playing_cards  then
                return {
                    func = function()
                card:start_dissolve()
                return true
            end,
                    message = "Well, this stinks. (cries)"
                }
        end
    end
}