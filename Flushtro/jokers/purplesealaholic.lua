SMODS.Joker{ --Purple Sealaholic
    key = "purplesealaholic",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Purple Sealaholic',
        ['text'] = {
            [1] = 'Applies {C:attention}Purple Seal{} to every card scored'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 15
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
    soul_pos = {
        x = 3,
        y = 15
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                context.other_card:set_seal("Purple", true)
                return {
                    message = "Card Modified!"
                }
        end
    end
}