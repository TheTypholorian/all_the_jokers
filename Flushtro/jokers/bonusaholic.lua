SMODS.Joker{ --Bonusaholic
    key = "bonusaholic",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Bonusaholic',
        ['text'] = {
            [1] = 'Makes every card scored',
            [2] = 'into {C:attention}bonus{} cards'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 7,
        y = 2
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                context.other_card:set_ability(G.P_CENTERS.m_bonus)
                return {
                    message = "Card Modified!"
                }
        end
    end
}