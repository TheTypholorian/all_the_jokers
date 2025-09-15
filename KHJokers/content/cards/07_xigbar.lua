SMODS.Joker {
    name = 'Half Face',
    key = 'xigbar',

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,     --1
                card.ability.extra.chips_gain --2
            }
        }
    end,

    rarity = 1,
    atlas = 'KHJokers',
    pos = { x = 1, y = 2 },
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            chips = 0,
            chips_gain = 130,
            count = 0
        }
    },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            card.ability.extra.count = 0
            for k, v in ipairs(context.scoring_hand) do
                v.scoring = true
            end

            for k, v in ipairs(context.full_hand) do
                if not v.scoring and v:is_face() then
                    card.ability.extra.count = card.ability.extra.count + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end,
                    }))
                    card_eval_status_text(card, "extra", nil, nil, nil, {
                        message = tostring(card.ability.extra.count),
                        colour = G.C.PURPLE,
                    })
                end
            end

            for k, v in ipairs(context.scoring_hand) do
                v.scoring = nil
            end
        end

        if context.joker_main then
            card.ability.extra.chips = card.ability.extra.count * card.ability.extra.chips_gain

            return {
                chips = card.ability.extra.chips
            }
        end
    end

}
