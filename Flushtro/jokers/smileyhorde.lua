SMODS.Joker{ --Smiley Horde
    key = "smileyhorde",
    config = {
        extra = {
            Mult = 8
        }
    },
    loc_txt = {
        ['name'] = 'Smiley Horde',
        ['text'] = {
            [1] = '{C:mult}+#1#{} Mult'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 17
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Mult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    mult = card.ability.extra.Mult,
                    extra = {
                        mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult,
                        extra = {
                            mult = card.ability.extra.Mult
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