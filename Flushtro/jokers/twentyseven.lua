SMODS.Joker{ --twenty seven
    key = "twentyseven",
    config = {
        extra = {
            Retriggers = 27
        }
    },
    loc_txt = {
        ['name'] = 'twenty seven',
        ['text'] = {
            [1] = 'retriggers a card {s:3,C:attention}#1#{} times'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 19
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 54,
    rarity = "flush_mythical",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Retriggers}}
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play  then
                return {
                    repetitions = card.ability.extra.Retriggers,
                    message = localize('k_again_ex')
                }
        end
    end
}