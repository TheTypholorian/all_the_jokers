SMODS.Joker{ --Fallen angel
    key = "fallenangel",
    config = {
        extra = {
            hypermult_n = 1.1,
            hypermult_arrows = 3,
            hypermult_n2 = 1.5,
            hypermult_arrows2 = 3
        }
    },
    loc_txt = {
        ['name'] = 'Fallen angel',
        ['text'] = {
            [1] = '{X:black,C:red,s:1.3} ^^^1.1{} Mult, {X:planet,C:white,E:2,s:1.2} Almanetic {} jokers give {X:black,C:red} ^^^1.5 {} Mult each',
            [2] = '{C:red,E:1,s:0.7}please... help me...{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    display_size = {
        w = 71 * 1.25, 
        h = 95 * 1.25
    },
    cost = 0,
    rarity = "cokelatr_incomprehensible",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    hypermult = {
    card.ability.extra.hypermult_arrows,
    card.ability.extra.hypermult_n
}
                }
        end
        if context.other_joker  then
            if (function()
    return context.other_joker.config.center.rarity == "cokelatr_almanetic"
end)() then
                return {
                    hypermult = {
    card.ability.extra.hypermult_arrows2,
    card.ability.extra.hypermult_n2
}
                }
            end
        end
    end
}