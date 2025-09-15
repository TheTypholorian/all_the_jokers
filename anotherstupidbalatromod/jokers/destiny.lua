SMODS.Joker{ --Destiny
    key = "destiny",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Destiny',
        ['text'] = {
            [1] = 'All played {C:orange}Ace{} become {C:orange}Lucky{} cards when scored'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 5
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

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 14 then
                context.other_card:set_ability(G.P_CENTERS.m_lucky)
                return {
                    message = "Card Modified!"
                }
            end
        end
    end
}