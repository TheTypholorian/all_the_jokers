SMODS.Joker {
  key = 'binary',
  loc_txt = {
    name = 'Binary Joker',
    text = {
      'This Joker has a',
      '{C:green}#1# in #2#{} chance of gaining',
      '{C:chips}+#3#{} chips and {C:mult}+#4#{} Mult',
      'at the end of each blind',
      '{C:inactive}(Currently {C:chips}+#5#{}{C:inactive} Chips and {C:mult}+#6#{} Mult)'
    }
  },

  config = { extra = { odds = 2, chips_gain = 10, mult_gain = 2, chips = 0, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 4 },
  cost = 4,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.chips_gain, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult
      }
    end

    if context.end_of_round and pseudorandom('binary') < G.GAME.probabilities.normal / card.ability.extra.odds and not context.repetition and context.game_over == false then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

      return { message = localize('k_upgrade_ex') }
    end
  end
}
