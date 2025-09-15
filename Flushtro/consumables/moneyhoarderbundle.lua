SMODS.Consumable {
    key = 'moneyhoarderbundle',
    set = 'bundle',
    pos = { x = 4, y = 1 },
    config = { extra = {
        dollars_value = 30
    } },
    loc_txt = {
        name = 'Money Hoarder Bundle',
        text = {
        [1] = 'This bundle comes with:',
        [2] = '- {C:attention}Bull{}',
        [3] = '- {C:attention}Bootstraps{}',
        [4] = '- {C:money}$30',
        [5] = '{C:inactive}(Must have room) {}'
    }
    },
    cost = 1,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      SMODS.add_card({ set = 'Joker', key = 'j_bull' })
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
            G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      SMODS.add_card({ set = 'Joker', key = 'j_bootstraps' })
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+"..tostring(30).." $", colour = G.C.MONEY})
                    ease_dollars(30, true)
                    return true
                end
            }))
            delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}