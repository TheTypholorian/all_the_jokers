SMODS.Joker {
    name = 'Roxas',
    key = 'roxas',

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips_gain,         --1
                card.ability.extra.discards,           --2
                card.ability.extra.discards_remaining, --3
                card.ability.extra.chips               --4
            }
        }
    end,

    rarity = 2,
    atlas = 'KHJokers',
    pos = { x = 1, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            chips = 0,
            chips_gain = 13,
            discards = 13,
            discards_remaining = 13
        }
    },

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
            }
        elseif context.discard and not context.blueprint then
            if card.ability.extra.discards_remaining <= 1 then
                card.ability.extra.discards_remaining = card.ability.extra.discards
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                return {
                    message = localize('k_upgrade_ex'),
                }
            else
                card.ability.extra.discards_remaining = card.ability.extra.discards_remaining - 1
            end
        end
    end
}
