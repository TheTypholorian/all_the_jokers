SMODS.Joker{ --Megalophobia
    key = "megalophobia",
    config = {
        extra = {
            Xmult = 3
        }
    },
    loc_txt = {
        ['name'] = 'Megalophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of large objects{}{}',
            [2] = '-------------------------',
            [3] = 'If your deck is {C:attention}> 52{} cards,',
            [4] = 'gain {X:red,C:white}X3{} {C:red}Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
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
        if context.cardarea == G.jokers and context.joker_main  then
            if #G.playing_cards > 52 then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}