SMODS.Consumable {
    key = 'bundle',
    set = 'ether',
    pos = { x = 3, y = 0 },
    config = { extra = {
        odds = 3,
        odds2 = 10,
        
        consumable_count = 1
    } },
    loc_txt = {
        name = 'Ethereal Bundle',
        text = {
        [1] = '{C:green}#1# in #2#{} chance to give:',
        [2] = '{C:attention}-Ethereal joker{}',
        [3] = '{C:attention}-Mitosis{}',
        [4] = '{C:attention}- Horizon{}',
        [5] = 'additional {C:green}1 in 10{} chance for',
        [6] = 'a random {C:enhanced,E:1,s:1.3}prime ethereal{}',
        [7] = '{C:inactive}(must have room){}'
    }
    },
    cost = 8,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.odds4, card.ability.extra.odds11}}
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
            if SMODS.pseudorandom_probability(card, 'group_0_9050f83c', 1, card.ability.extra.odds, 'c_cokelatr_bundle', false) then
                
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                          G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                      local new_joker = SMODS.add_card({ set = 'Joker', key = 'j_cokelatr_eth' })
                      if new_joker then
                      end
                          G.GAME.joker_buffer = 0
                      end
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
                for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
            play_sound('timpani')
            SMODS.add_card({ key = 'c_cokelatr_mitosis'})                            
            used_card:juice_up(0.3, 0.5)
            return true
        end
        }))
    end
    delay(0.6)
                for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
            play_sound('timpani')
            SMODS.add_card({ key = 'c_cokelatr_horizon'})                            
            used_card:juice_up(0.3, 0.5)
            return true
        end
        }))
    end
    delay(0.6)
            end
            if SMODS.pseudorandom_probability(card, 'group_1_19aa12c9', 1, card.ability.extra.odds2, 'c_cokelatr_bundle', true) then
                
                for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
            play_sound('timpani')
            SMODS.add_card({ set = primes, })                            
            used_card:juice_up(0.3, 0.5)
            return true
        end
        }))
    end
    delay(0.6)
            end
    end,
    can_use = function(self, card)
        return true
    end
}