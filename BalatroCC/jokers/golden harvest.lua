SMODS.Joker {
    key = 'bccp_golden_harvest',
    loc_txt = {
        name = "Golden Harvest",
        text = {
            "Played cards give {C:mult}+#1#{}",
            "Mult for {C:attention}#2#{} hands",
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    -- Only appears if Ducasse is extinct (adjust flag name as needed to match your mod's pool_flag style)
    yes_pool_flag = 'vpp_ducasse_extinct',
    config = { extra = { mult = 8, hands_left = 50 } },
    rarity = 1, -- Common
    atlas = 'ModdedVanilla',
    pos = { x = 2, y = 2 },
    cost = 6,
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
                G.GAME.pool_flags.vpp_ducasse_extinct = true
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
                                return true;
                            end
                        }))
                        return true
                    end
                }))
            else
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            end
        end
    end,
    in_pool = function(self, args) -- equivalent to `yes_pool_flag = 'vremade_gros_michel_extinct'`
        return G.GAME.pool_flags.vpp_ducasse_extinct
    end
}