SMODS.Joker {
    key = 'sherba',
    atlas = 'Jokers',
    pos = {x = 0, y = 1},
    soul_pos = {x = 1, y = 1},
    blueprint_compat = true,
    rarity = 4,
    cost = 20,
    config = {
        extra = {
        }
    },

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint and context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true) -- Jiggle if active
        end

        if context.repetition and context.cardarea == G.play then
            if G.GAME.current_round.hands_played == 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = G.GAME.current_round.hands_left,
                    card = card
                }
            end
        end
    end,
    
    joker_display_def = function(JokerDisplay) -- Joker Display integration
        return {
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            
            calc_function = function(card)
                card.joker_display_values.active = (G.GAME and G.GAME.current_round.hands_played == 0 and localize("jdis_active") or localize("jdis_inactive"))
            end,

            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                if not (G.GAME and G.GAME.current_round.hands_played == 0) then return 0 end
                return (G.GAME.current_round.hands_left - 1) * JokerDisplay.calculate_joker_triggers(joker_card)
            end
        }
    end
}