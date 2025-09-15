SMODS.Joker{ --Destructful Noob
    key = "destructfulnoob",
    config = {
        extra = {
            Xmult = 7625597484987
        }
    },
    loc_txt = {
        ['name'] = 'Destructful Noob',
        ['text'] = {
            [1] = '{X:mult,C:white}X7,625,597,484,987{} Mult'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 50,
    rarity = "flush_mythical",
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
    end
}