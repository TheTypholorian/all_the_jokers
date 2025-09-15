SMODS.Joker{ --Polychromaholic
    key = "polychromaholic",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Polychromaholic',
        ['text'] = {
            [1] = 'Applies {C:edition}Polychrome{} to every card scored'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 14
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 15,
    rarity = "flush_epic",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 6,
        y = 14
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                context.other_card:set_edition("e_polychrome", true)
                return {
                    message = "Card Modified!"
                }
        end
    end
}