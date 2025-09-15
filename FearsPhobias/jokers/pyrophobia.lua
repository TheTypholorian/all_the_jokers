SMODS.Joker{ --Pyrophobia
    key = "pyrophobia",
    config = {
        extra = {
            chips = 8,
            mult = 4
        }
    },
    loc_txt = {
        ['name'] = 'Pyrophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of fire.{}{}',
            [2] = '---------------------',
            [3] = '{C:hearts}Hearts{} give {C:blue}+8 Chips{}',
            [4] = '{C:spades}Spades{} give {C:red}+4 Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 3
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Hearts") then
                return {
                    chips = card.ability.extra.chips
                }
            elseif context.other_card:is_suit("Spades") then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}