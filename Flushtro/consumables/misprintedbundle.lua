SMODS.Consumable {
    key = 'misprintedbundle',
    set = 'bundle',
    pos = { x = 3, y = 1 },
    loc_txt = {
        name = 'Misprinted Bundle',
        text = {
        [1] = 'This bundle comes with:',
        [2] = '- {C:attention}Misprint{}',
        [3] = '- {C:attention}MisprintMisprint{}',
        [4] = '- {C:attention}MisprintMisprintMisprint{}',
        [5] = '{C:inactive}(Must have room) {}'
    }
    },
    cost = 17,
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
                      SMODS.add_card({ set = 'Joker', key = 'j_misprint' })
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
                      SMODS.add_card({ set = 'Joker', key = 'j_flush_misprintmisprint' })
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
                      SMODS.add_card({ set = 'Joker', key = 'j_flush_misprintmisprintmisprint' })
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}