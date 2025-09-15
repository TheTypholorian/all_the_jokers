SMODS.Joker {
    name = 'Nobody',
    key = 'nobody',

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips, --1
                card.ability.extra.chips_gain -- 2
            }
        }
    end,

    rarity = 4,
    atlas = 'KHJokers',
    pos = { x = 0, y = 1 },
    soul_pos = { x = 0, y = 2 },
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    eternal = false,
    perishable_compat = true,

    config = {
        extra = {
            chips = 0,
            chips_gain = 13
        }
    },

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            local suits = {}
            for _, v in ipairs(context.scoring_hand) do
                suits[v.base.suit] = true
            end

            local unique_suits = 0
            for _ in pairs(suits) do
                unique_suits = unique_suits + 1
            end

            local total_chips = unique_suits * card.ability.extra.chips_gain
            card.ability.extra.chips = card.ability.extra.chips + total_chips

            return {
                message = '+' .. total_chips,
                colour = G.C.CHIPS
            }
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}
