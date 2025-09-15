SMODS.Consumable {
    key = 'gamblerbundle',
    set = 'bundle',
    pos = { x = 4, y = 0 },
    loc_txt = {
        name = 'Gambler Bundle',
        text = {
        [1] = 'This bundle comes with:',
        [2] = '- {C:attention}Chance Plush{}',
        [3] = '- {C:attention}Pls Legendary{}',
        [4] = '- {C:attention}Oops! All 6s',
        [5] = '{C:inactive}(Must have room) {}'
    }
    },
    cost = 15,
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
                      SMODS.add_card({ set = 'Joker', key = 'j_flush_chanceplush' })
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
                      SMODS.add_card({ set = 'Joker', key = 'j_flush_plslegendary' })
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
                      SMODS.add_card({ set = 'Joker', key = 'j_oops' })
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