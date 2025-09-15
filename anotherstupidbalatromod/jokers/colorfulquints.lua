SMODS.Joker{ --Colorful Quints
    key = "colorfulquints",
    config = {
        extra = {
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Colorful Quints',
        ['text'] = {
            [1] = '{X:red,C:white}X3{} Mult if played hand contains a {C:orange}Five of Kind{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 3
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

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Flush" then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}