-- Toilet
SMODS.Joker {
    key = "bccp_space_junk",
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 5,
    pos = { x = 0, y = 2 },

    config = { extra = { flush_played = false } },

    loc_txt = {
        name = "Space Junk",
        text = {
            "If no {C:attention}Flush{} is played this round,",
            "create a {C:planet}Jupiter{} planet card"
        }
    },


    calculate = function(self, card, context)
        -- Check each hand: did the player play a Flush?
        if context.joker_main and next(context.poker_hands['Flush']) then
            card.ability.extra.flush_played = true
            return true
        end

        -- End of round: if no Flush was played, grant Flush planet
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if not card.ability.extra.flush_played 
                and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        SMODS.add_card({ key = 'c_jupiter' }) -- Flush planet
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
            end
            -- Reset tracking for next round
            card.ability.extra.flush_played = false
        end
    end
}
