SMODS.Joker{ --Robbery
    key = "robbery",
    config = {
        extra = {
            reroll_amount = 1,
            Money = 1250
        }
    },
    loc_txt = {
        ['name'] = 'Robbery',
        ['text'] = {
            [1] = 'gain {C:money}$#1#{} when shop',
            [2] = 'is {C:attention}exited{}',
            [3] = 'Rerolls are {C:attention}free{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 16
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 100,
    rarity = "flush_resplendant",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 2,
        y = 16
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Money}}
    end,

    calculate = function(self, card, context)
        if context.ending_shop  then
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.reroll_amount)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-(card.ability.extra.reroll_amount))
    end
}