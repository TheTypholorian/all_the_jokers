SMODS.Joker{ --Hologramaholic
    key = "hologramaholic",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Hologramaholic',
        ['text'] = {
            [1] = 'Applies {C:edition}Hologram{} to every card scored'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 9
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
        x = 8,
        y = 9
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                context.other_card:set_edition("e_holo", true)
                return {
                    message = "Card Modified!"
                }
        end
    end
}