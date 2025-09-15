SMODS.Joker {
    key = "ms_fortune",
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { numerator = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.numerator, 0 } }
    end,
    rarity = 3,
    cost = 7,
    atlas = "Jokers",
    pos = { x = 1, y = 1 },
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * card.ability.extra.numerator
            }
        end
        if context.ending_shop then
            return {
                dollars = -G.GAME.dollars
            }
        end
    end,
}