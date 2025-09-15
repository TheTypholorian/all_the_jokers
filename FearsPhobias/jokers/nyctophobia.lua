SMODS.Joker{ --Nyctophobia
    key = "nyctophobia",
    config = {
        extra = {
            mult = 10
        }
    },
    loc_txt = {
        ['name'] = 'Nyctophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of the dark.{}{}',
            [2] = '----------------------',
            [3] = '{C:red}+10 Mult{} for every {C:spades}Spade{}',
            [4] = 'played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 2
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
            if context.other_card:is_suit("Spades") then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}