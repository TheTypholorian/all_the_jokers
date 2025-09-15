SMODS.Joker{ --Flower Boy
    key = "flowerboy",
    config = {
        extra = {
            mult = 20,
            mult2 = 20,
            mult3 = 20,
            mult4 = 20
        }
    },
    loc_txt = {
        ['name'] = 'Flower Boy',
        ['text'] = {
            [1] = '{C:red}+20{} {C:red}+20{} {C:red}+20{} {C:red}+20 {}Mult'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["shit_tyler"] = true },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    mult = card.ability.extra.mult,
                    extra = {
                        mult = card.ability.extra.mult2,
                        extra = {
                            mult = card.ability.extra.mult3,
                        extra = {
                            mult = card.ability.extra.mult4,
                        extra = {
                            message = "Vision",
                            colour = G.C.RED,
                        extra = {
                            message = "Jimbo hit me, jimbo hit me with precision, I-",
                            colour = G.C.RED,
                        extra = {
                            message = "Wonder if you look both ways",
                            colour = G.C.RED,
                        extra = {
                            message = "When you cross my mind",
                            colour = G.C.RED
                        }
                        }
                        }
                        }
                        }
                        }
                        }
                }
        end
    end
}