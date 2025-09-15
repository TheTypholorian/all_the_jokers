SMODS.Joker {
	name = 'Bryce The Nobody',
	key = 'brycethenobody',

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.odds,
			'bryce1')
		return {
			vars = {
				card.ability.extra.mult, --1
				numerator,   --2
				denominator, --3
			}
		}
	end,

	rarity = 2,
	atlas = 'KHJokers',
	pos = { x = 1, y = 3 },
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	config = {
		extra = {
			mult = 3,
			base = 1,
			odds = 2
		}
	},

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit("Hearts") then
				if SMODS.pseudorandom_probability(card, 'bryce', card.ability.extra.base, card.ability.extra.odds, 'bryce1') then
					context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
					context.other_card.ability.perma_mult = context.other_card.ability.perma_mult +
						card.ability.extra.mult
					return {
						extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
						card = card
					}
				end
			end
		end
	end
}
