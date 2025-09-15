SMODS.Joker{ --Elon Credit Card
    key = "eloncreditcard",
    config = {
        extra = {
            debt_amount = 1
        }
    },
    loc_txt = {
        ['name'] = 'Elon Credit Card',
        ['text'] = {
            [1] = 'Go up to {C:red}-$100{} in debt'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 1,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt_amount
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt_amount
    end
}