SMODS.Joker{ --Thanatophobia
    key = "thanatophobia",
    config = {
        extra = {
            xchips = 2
        }
    },
    loc_txt = {
        ['name'] = 'Thanatophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of death.{}{}',
            [2] = '-------------------------',
            [3] = 'First round gives {X:blue,C:white}X2{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 3
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if G.GAME.current_round.hands_played == 0 then
                return {
                    x_chips = card.ability.extra.xchips
                }
            end
        end
    end
}