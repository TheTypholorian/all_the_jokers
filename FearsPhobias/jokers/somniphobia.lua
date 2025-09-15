SMODS.Joker{ --Somniphobia
    key = "somniphobia",
    config = {
        extra = {
            Xmult = 3
        }
    },
    loc_txt = {
        ['name'] = 'Somniphobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of sleep{}{}',
            [2] = '---------------------',
            [3] = 'If remaining hands = 1,',
            [4] = 'gain {X:red,C:white}X3{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 3
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
            if G.GAME.current_round.hands_left == 1 then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}