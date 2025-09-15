SMODS.Consumable {
    key = 'thealerto',
    set = 'Tarot',
    pos = { x = 0, y = 2 },
    loc_txt = {
        name = 'The Alerto',
        text = {
        [1] = 'create an {X:default,C:white}Alerto{} joker',
        [2] = '{C:inactive}(Must have room){}'
    }
    },
    cost = 9,
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
                      SMODS.add_card({ set = 'Joker', rarity = 'flush_alerto' })
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