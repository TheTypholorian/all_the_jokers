SMODS.Joker{ --Kenophobia
    key = "kenophobia",
    config = {
        extra = {
            xchips = 2
        }
    },
    loc_txt = {
        ['name'] = 'Kenophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of empty spaces{}{}',
            [2] = '------------------------------',
            [3] = 'If your deck size is {C:attention}< 50 cards{},',
            [4] = 'gain {X:blue,C:white}X2{} {C:blue}Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
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
            if #G.deck.cards < 50 then
                return {
                    x_chips = card.ability.extra.xchips
                }
            end
        end
    end
}