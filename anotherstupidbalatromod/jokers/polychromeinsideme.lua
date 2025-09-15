SMODS.Joker{ --Polychrome inside me
    key = "polychromeinsideme",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Polychrome inside me',
        ['text'] = {
            [1] = 'if scored card without {C:dark_edition}Edition{}, adds Polychrome'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 13
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    set_ability = function(self, card, initial)
        card:set_edition("e_polychrome", true)
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card.edition == nil then
                context.other_card:set_edition("e_polychrome", true)
                return {
                    message = "Card Modified!"
                }
            end
        end
    end
}