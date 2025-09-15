SMODS.Consumable {
    key = 'starterpackbundle',
    set = 'bundle',
    pos = { x = 9, y = 1 },
    config = { extra = {
        dollars_value = 25
    } },
    loc_txt = {
        name = 'Starter Pack Bundle',
        text = {
        [1] = 'This bundle comes with:',
        [2] = '- {C:attention}Gros Michel{}',
        [3] = '- {C:attention}Supernova{}',
        [4] = '- {C:money}$25{}',
        [5] = '{C:inactive}(Must have room) {}'
    }
    },
    cost = 4,
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
                      SMODS.add_card({ set = 'Joker', key = 'j_gros_michel' })
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
                      SMODS.add_card({ set = 'Joker', key = 'j_supernova' })
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+"..tostring(25).." $", colour = G.C.MONEY})
                    ease_dollars(25, true)
                    return true
                end
            }))
            delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}