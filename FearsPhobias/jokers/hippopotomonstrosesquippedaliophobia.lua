SMODS.Joker{ --Hippopotomonstrosesquippedaliophobia
    key = "hippopotomonstrosesquippedaliophobia",
    config = {
        extra = {
            Xmult = 5
        }
    },
    loc_txt = {
        ['name'] = 'Hippopotomonstrosesquippedaliophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of long words{}{}',
            [2] = '----------------------------------------------',
            [3] = '{C:attention}Five of a Kind{} gives {X:red,C:white}X5{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
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
        if context.cardarea == G.jokers and context.joker_main  then
            if next(context.poker_hands["Five of a Kind"]) then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}