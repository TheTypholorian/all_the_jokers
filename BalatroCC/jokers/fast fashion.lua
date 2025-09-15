-- Fast Fashion
SMODS.Joker {
    key = "bccp_fast_fashion",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 4, y = 2 },

    loc_txt = {
        name = "Fast Fashion",
        text = {
            "{X:mult,C:white}3x{} Mult, lose {C:money}5${}",
            "when a hand is played"
        }
    },

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 0 then
            
            -- Add negative dollars to the buffer
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - 5

            -- Trigger money loss animation
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "-$5",
                        colour = G.C.MONEY,
                        card = card
                    })
                    -- Apply the buffered dollars to the game
                    ease_dollars(G.GAME.dollar_buffer)
                    G.GAME.dollar_buffer = 0
                    return true
                end
            }))

            return {
                xmult = 3,
            }
        end
    end,
}
