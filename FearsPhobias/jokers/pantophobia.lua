SMODS.Joker{ --Pantophobia
    key = "pantophobia",
    config = {
        extra = {
            Xmult = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'Pantophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of everything{}{}',
            [2] = '---------------------',
            [3] = 'Every played card',
            [4] = 'gives {X:red,C:white}X1.5{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 2
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
                return {
                    Xmult = card.ability.extra.Xmult
                }
        end
    end
}