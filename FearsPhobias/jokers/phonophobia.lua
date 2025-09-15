SMODS.Joker{ --Phonophobia
    key = "phonophobia",
    config = {
        extra = {
            chips = 8,
            mult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Phonophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of loud sounds{}{}',
            [2] = '-----------------------',
            [3] = 'If a Pair is played,',
            [4] = 'gain {C:blue}+8 Chips{} and {C:red}+2 Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Pair" then
                return {
                    chips = card.ability.extra.chips,
                    extra = {
                        mult = card.ability.extra.mult
                        }
                }
            end
        end
    end
}