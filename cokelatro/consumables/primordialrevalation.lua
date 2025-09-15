SMODS.Consumable {
    key = 'primordialrevalation',
    set = 'primes',
    pos = { x = 4, y = 1 },
    config = { extra = {
        odds = 5
    } },
    loc_txt = {
        name = 'Primordial Revalation',
        text = {
        [1] = '{C:green}1 in 5{} chance to create a random {X:planet,C:white,E:2,s:1.3}ALMANETIC {}{C:attention} Joker {}'
    }
    },
    cost = 100,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            if SMODS.pseudorandom_probability(card, 'group_0_2daaeebf', 1, card.ability.extra.odds, 'c_cokelatr_primordialrevalation', true) then
                
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                          G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                      local new_joker = SMODS.add_card({ set = 'Joker', rarity = 'cokelatr_almanetic' })
                      if new_joker then
                      end
                          G.GAME.joker_buffer = 0
                      end
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
            end
    end,
    can_use = function(self, card)
        return true
    end
}