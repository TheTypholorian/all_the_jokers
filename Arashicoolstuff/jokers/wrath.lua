SMODS.Joker{ --Wrath
    key = "wrath",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Wrath',
        ['text'] = {
            [1] = 'Always spawns {C:legendary}Eternal{}',
            [2] = 'All played cards become {C:attention}Glass{}',
            [3] = 'Idea by {X:legendary,C:white}Ridry{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 3
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                context.other_card:set_ability(G.P_CENTERS.m_glass)
                return {
                    message = "Card Modified!"
                }
        end
    end
}