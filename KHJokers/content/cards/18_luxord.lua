SMODS.Joker {
    name = 'Luxord',
    key = 'luxord',

    loc_vars = function(self, info_queue, card)
        local vars = {
            card.ability.chips,      --1
            card.ability.cap,        --2
            card.ability.chips_gain, --3
            card.ability.extra_time, --4
            card.ability.chips_extra --5
        }
        local main_end = {
            {
                n = G.UIT.T,
                config = {
                    text = "(Currently +",
                    colour = G.C.UI.TEXT_INACTIVE,
                    scale = 0.32
                }
            },

            {
                n = G.UIT.T,
                config = {
                    ref_table = card.ability,
                    ref_value = "chips",
                    colour = G.C.CHIPS,
                    scale = 0.32
                }
            },
            {
                n = G.UIT.T,
                config = {
                    text = "/ " .. tostring(card.ability.cap) .. " Chips)",
                    colour = G.C.UI.TEXT_INACTIVE,
                    scale = 0.32
                }
            }
        }
        return { main_end = main_end, vars = vars }
    end,
    rarity = 1,
    atlas = 'KHJokers',
    pos = { x = 1, y = 4, },
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    config = {
        chips = 0,
        cap = 100,
        chips_gain = 5,
        time_spent = 0,
        extra_time = 10,
        chips_extra = 1,
        active = false,
        destroying = false,
        juice_up = false
    },

    update = function(self, card, dt)
        if card.ability.active then
            if not G.SETTINGS.paused then
                card.ability.time_spent = card.ability.time_spent + G.real_dt
                card.ability.chips = 0 + (math.floor(card.ability.time_spent) * card.ability.chips_gain)
            end
        end

        if card.ability.chips >= card.ability.cap and not card.ability.destroying then
            card.ability.destroying = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        blockable = false,
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Times up!' })
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                        end
                    }))
                    return true
                end
            }))
        end
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            card.ability.destroying = false
            card.ability.active = true
            card.ability.chips = 0
            card.ability.time_spent = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Start!' })
            card.ability.juice_up = true
            juice_card_until(card, function(c)
                return card.ability.juice_up and not c.REMOVED
            end, true)
        end

        if context.individual and context.cardarea == G.play then
            card.ability.cap = card.ability.cap + card.ability.extra_time
        end

        if context.joker_main and card.ability.chips > 0 then
            card.ability.chips_gain = card.ability.chips_gain + card.ability.chips_extra
            return {
                chips = card.ability.chips,
            }
        end

        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.destroying = false
            card.ability.active = false
            card.ability.chips = 0
            card.ability.time_spent = 0
            card.ability.juice_up = false
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Reset!' })
        end
    end,
}
