SMODS.Joker{
    name = "Scratch Card",
    key = "bccp_scratch_card",
    config = {
        extra = {
            min_gain = 5,
            max_gain = 15
        }
    },
    loc_txt = {
        name = "Scratch Card",
        text = {
            "At end of {C:attention}shop{} destroy",
            "this joker and gain",
            "between {C:money}$#1#{} and {C:money}$#2#{}",
        }
    },
    pos = { x = 1, y = 5 },
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min_gain, card.ability.extra.max_gain}}
    end,

    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint then
            local gain = math.random(card.ability.extra.min_gain, card.ability.extra.max_gain)
            if gain > 0 then
                ease_dollars(gain)
                -- Show an animation with the amount gained
                card:juice_up(0.5, 0.5)
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "$" .. gain,
                    colour = G.C.MONEY,
                    card = card
                })
            end
            G.jokers:remove_card(card)
            card:remove()
            card = nil
        end
    end
}