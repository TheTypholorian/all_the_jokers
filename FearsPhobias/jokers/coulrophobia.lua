SMODS.Joker{ --Coulrophobia
    key = "coulrophobia",
    config = {
        extra = {
            chips = 15
        }
    },
    loc_txt = {
        ['name'] = 'Coulrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of clowns.{}{}',
            [2] = '----------------------',
            [3] = 'Wild cards give {C:blue}+15 Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_wild"] == true then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}