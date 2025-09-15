-- Curtain Call
SMODS.Joker {
    key = "bccp_curtain_call",
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 0, y = 5 },

    config = { extra = { hand_count = 0 } },

    loc_txt = {
        name = "Curtain Call",
        text = {
            "If round is won in",
            "exactly {C:attention} 3 hands{}, create",
            "a {C:planet}Venus{} planet card"
        }
    },

    calculate = function(self, card, context)
        -- Track number of hands played in the round
        if context.joker_main then
            card.ability.extra.hand_count = (card.ability.extra.hand_count or 0) + 1
            return true
        end

        -- At end of round, check win and hand count
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
            if (card.ability.extra.hand_count or 99) == 3 then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = function()
                            SMODS.add_card({ key = 'c_venus' }) -- Venus planet
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
                end
            end
            -- Reset for next round
            card.ability.extra.hand_count = 0
        end
    end
}
