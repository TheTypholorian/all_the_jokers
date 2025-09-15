-- Bubble
SMODS.Joker {
    key = "bccp_bubble",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 0, y = 4 },
    config = { extra = { base_mult = 1, increment = 0.1, dollars_per_increment = 5 } },

    loc_txt = {
        name = "Bubble",
        text = {
            "Gains {X:mult,C:white}0.1x{} for every {C:money}$5{}", -- manually update vals here!!
            "Chance to pop also increases",
            "{C:inactive}(Currently: {X:mult,C:white}#3#x{C:inactive})"
        }
    },

    loc_vars = function(self, info_queue, card)
        local total_dollars = (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)
        local increments = math.floor(total_dollars / card.ability.extra.dollars_per_increment)
        local current_mult = card.ability.extra.base_mult + increments * card.ability.extra.increment
        local destruction_chance = math.min(total_dollars / 5000, 1) -- capped at 100%
        return { vars = { card.ability.extra.base_mult, increments * card.ability.extra.increment, current_mult, destruction_chance } }
    end,

    calculate = function(self, card, context)
        local total_dollars = (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)
        local increments = math.floor(total_dollars / card.ability.extra.dollars_per_increment)
        local current_mult = card.ability.extra.base_mult + increments * card.ability.extra.increment
        local destruction_chance = math.min(total_dollars / 5000, 1) -- capped at 100%

        -- Main multiplier calculation
        if context.joker_main then
            return { xmult = current_mult }
        end

        -- Self-destruction check at end of round
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if love.math.random() < destruction_chance then
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
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return { message = "Pop!" }
            else
                return { message = localize('k_safe_ex') }
            end
        end
    end
}