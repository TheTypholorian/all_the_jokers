-- Magnesium (Flush House)
SMODS.Consumable {
    key = 'generic999999',
    set = 'generic',
    pos = { x = 4, y = 2 },
    config = { extra = {
        hand_type = "Flush House",
        levels = 25
    } },
    loc_txt = {
        name = 'Magnesium',
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.extra.hand_type].level,
                localize(card.ability.extra.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.extra.hand_type].l_mult + (card.ability.extra.levels * G.GAME.hands[card.ability.extra.hand_type].l_mult),
                G.GAME.hands[card.ability.extra.hand_type].l_chips + (card.ability.extra.levels * G.GAME.hands[card.ability.extra.hand_type].l_chips),
                colours = { (G.GAME.hands[card.ability.extra.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.extra.hand_type].level)]) }
            }
        }
    end,
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                { handname = localize('Flush House', 'poker_hands'), 
                  chips = G.GAME.hands['Flush House'].chips, 
                  mult = G.GAME.hands['Flush House'].mult, 
                  level = G.GAME.hands['Flush House'].level })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = true
                    return true
                end
            }))
            update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.9,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    return true
                end
            }))
            update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.9,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = nil
                    return true
                end
            }))
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+'..tostring(25) })
            delay(1.3)
            level_up_hand(card, "Flush House", true, 25)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, 
                {handname=localize('Flush House', 'poker_hands'), 
                 chips = G.GAME.hands['Flush House'].chips, 
                 mult = G.GAME.hands['Flush House'].mult, 
                 level=G.GAME.hands['Flush House'].level})
            delay(1.3)
    end,
    can_use = function(self, card)
        return true
    end
}