SMODS.Joker{ --Nosocomephobia
    key = "nosocomephobia",
    config = {
        extra = {
            mult = 20
        }
    },
    loc_txt = {
        ['name'] = 'Nosocomephobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of hospitals{}{}',
            [2] = '-----------------------',
            [3] = 'If your hand size is {C:attention}< 8{},',
            [4] = 'gain {C:red}+20 Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if G.hand.config.card_limit < 8 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}