SMODS.Joker{ --The daughter of Grager
    key = "hennie",
    config = {
        extra = {
            currentante = 0,
            Xmult = 3.5
        }
    },
    loc_txt = {
        ['name'] = 'The daughter of Grager',
        ['text'] = {
            [1] = '{X:red,C:white}X3.5{} Mult if ante is below 8'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 2
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
            if 8 > G.GAME.round_resets.ante then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}