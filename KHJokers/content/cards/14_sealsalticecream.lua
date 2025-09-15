local function create_consumable(joker, type, seed, key, message, colour)
    if #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit then -- checks space in consumable slots
        card_eval_status_text(joker, "extra", nil, nil, nil, {
            message = localize("k_no_space_ex")                                                   -- gives a "No Space!" message if there isn't any space
        })
        return
    end

    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event({
        trigger = "before",
        delay = 0.0,
        func = function()
            local card = create_card(type, G.consumeables, nil, nil, nil, nil, key, seed)
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0
            return true
        end
    }))

    card_eval_status_text(joker, "extra", nil, nil, nil, {
        message = localize(message),
        colour = colour
    })
end

SMODS.Joker {
    name = 'Seal Salt Ice Cream',
    key = "sealsalt",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
    end,

    rarity = 2,
    atlas = "KHJokers",
    pos = { x = 3, y = 1 },
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            seal = 'Blue'
        }
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint and not context.other_card.debuff then
            local seal = context.other_card.seal
            if seal == "Blue" then
                local key = 0

                if G.GAME.last_hand_played then
                    for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == G.GAME.last_hand_played then
                            key = v.key
                            break
                        end
                    end
                end
                create_consumable(card, "Planet", "seal", key, "k_plus_planet", G.C.SECONDARY_SET.Planet) -- creates planet card of played poker hand if card has a blue seal
            end
        end
    end,

    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card.seal == "Blue" then
                return true
            end
        end
        return false
    end
}
