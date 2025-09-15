SMODS.Joker {
	name = 'Meeska Mooska',
	key = 'mickey',

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.odds,
			'mickey1')
		return {
			vars = {
				numerator,         -- 1
				denominator,       -- 2
				card.ability.extra.x_mult, -- 3
				card.ability.extra.Xmult_gain, -- 4
				card.ability.extra.chips, -- 5
				card.ability.extra.chips_gain -- 6
			}
		}
	end,

	rarity = 2,
	atlas = 'KHJokers',
	pos = { x = 3, y = 0 },
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	config = {
		extra = {
			chips = 0,
			chips_gain = 4,
			x_mult = 1,
			Xmult_gain = 0.25,
			base = 1,
			odds = 4
		}
	},


	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card:get_id() == 13 then -- checks if scored card is a King
				if SMODS.pseudorandom_probability(card, 'mickey', card.ability.extra.base, card.ability.extra.odds, 'mickey1') then
					card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.Xmult_gain
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
					return {
						message = 'Upgraded!',
						card = card,
					}
				end
			end
		end

		if context.joker_main then
			return {
				xmult = card.ability.extra.x_mult,
				chips = card.ability.extra.chips,
				card = context.other_card

			}
		end
	end
}
