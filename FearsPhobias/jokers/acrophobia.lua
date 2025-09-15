SMODS.Joker{ --Acrophobia
    key = "acrophobia",
    config = {
        extra = {
            Xmult = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'Acrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of heights.{}{}',
            [2] = '-------------------------',
            [3] = 'Face cards give {X:red,C:white}X1.5{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_face() then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}