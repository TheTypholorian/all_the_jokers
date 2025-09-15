SMODS.Joker{ --Atychiphobia
    key = "atychiphobia",
    config = {
        extra = {
            hands = 1,
            permanent = 0
        }
    },
    loc_txt = {
        ['name'] = 'Atychiphobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of failure{}{}',
            [2] = '-----------------------------',
            [3] = 'Prevent losing the game once.',
            [4] = 'Destroys itself when it happens'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval  then
                return {
                    saved = true,
                    message = "SAVED!",
                    extra = {
                        func = function()
                card:start_dissolve()
                return true
            end,
                            message = "Destroyed!",
                        colour = G.C.RED,
                        extra = {
                            func = function()
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.hands).." Hand", colour = G.C.GREEN})
                
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
        
                return true
            end,
                            colour = G.C.GREEN
                        }
                        }
                }
        end
    end
}