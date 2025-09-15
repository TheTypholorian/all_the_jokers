SMODS.Joker {
    key = 'bccp_chapalote',
    loc_txt = {
        name = "Chapalote",
        text = {
            "Played cards give {C:mult}+#1#{}",
            "Mult for {C:attention}#2#{} hands",
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    config = { extra = { mult = 4, hands_left = 7 } },
    rarity = 1,
    atlas = 'ModdedVanilla',
    pos = { x = 1, y = 2 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.hands_left } }
    end,
    calculate = function(self, card, context)
        -- Give +mult for every card scored in played area
        if context.individual and context.cardarea == G.play and card.ability.extra.hands_left > 0 then
            return {
                mult = card.ability.extra.mult,
            }
        end
        -- At the end of a hand (after scoring), decrement hands_left and destroy if needed
        if context.after and not context.blueprint then
            if card.ability.extra.hands_left - 1 <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.vpp_ducasse_extinct = true
            else
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            end
        end
    end,
    in_pool = function(self, args)
        return not G.GAME.pool_flags.vpp_ducasse_extinct
    end
}