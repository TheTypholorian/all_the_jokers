SMODS.Joker{ --Wee Smiley
    key = "weesmiley",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Wee Smiley',
        ['text'] = {
            [1] = 'look at the smiley :D',
            [2] = '{C:inactive}does nothing other than{}',
            [3] = '{C:inactive}being a pet in your run{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 6,
        y = 20
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 1,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 7,
        y = 20
    },

    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end
}