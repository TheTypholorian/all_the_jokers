SMODS.Joker{ --Gold Sealaholic
    key = "goldsealaholic",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Gold Sealaholic',
        ['text'] = {
            [1] = 'Applies {C:attention}Gold Seal{} to every card scored'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 8
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 4,
        y = 8
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