SMODS.Joker{ --Freaky Joker
    key = "freakyjoker",
    config = {
        extra = {
            legendaryjokers = 0
        }
    },
    loc_txt = {
        ['name'] = 'Freaky Joker',
        ['text'] = {
            [1] = '{C:legendary}Legendary{} Jokers each give {X:red,C:white}X5{} Mult'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 7
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
                return {
                    Xmult = ((function() local count = 0; for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do if joker.config.center.rarity == 4 then count = count + 1 end end; return count end)()) * 5
                }
        end
    end
}