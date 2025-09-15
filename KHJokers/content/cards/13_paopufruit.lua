SMODS.Joker {
	name = 'Paopu Fruit',
	key = 'paopufruit',

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.odds,
			'paopu1')
		return {
			vars = {
				numerator, --1
				denominator --2
			}
		}
	end,

	rarity = 2,
	atlas = 'KHJokers',
	pos = { x = 2, y = 1 },
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,

	config = {
		extra = {
			repetitions = 1,
			base = 1,
			odds = 7
		}
	},

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:is_suit("Diamonds") then
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = card
				}
			end
		end

		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'paopu', card.ability.extra.base, card.ability.extra.odds, 'paopu1') then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				-- Extinct/Survival Message
				return {
					message = 'Riku, NO!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
		end
	end
}
