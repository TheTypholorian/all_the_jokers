SMODS.Joker{ --Glossophobia
    key = "glossophobia",
    config = {
        extra = {
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Glossophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of public speaking.{}{}',
            [2] = '-------------------------',
            [3] = 'High Card gives {X:red,C:white}X2{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 1
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
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "High Card" then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}