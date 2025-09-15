SMODS.Joker {
  key = 'pop_star',
  loc_txt = {
    name = 'Pop Star',
    text = {
      '{C:green}#1# in #2#{} chance',
      'for {C:attention}each scored card{}',
      'to gain a {C:attention}new{},',
      '{C:attention}random enhancement{}'
    }
  },

  config = { extra = { odds = 4 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if v.debuff == false and pseudorandom('pop_star') < G.GAME.probabilities.normal / card.ability.extra.odds then
          math.randomseed(pseudorandom('pop_star'))
          enhancement_index = math.random(1, #G.P_CENTER_POOLS['Enhanced'])
          enhancement = G.P_CENTER_POOLS['Enhanced'][enhancement_index]
          v:set_ability(enhancement, nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}
