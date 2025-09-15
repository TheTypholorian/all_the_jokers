SMODS.Joker {
	name = 'Sora',
	key = 'sora',

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult, --1
				card.ability.extra.Xmult_gain --2
			}
		}
	end,

	rarity = 3,
	atlas = 'KHJokers',
	pos = { x = 0, y = 0 },
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	config = {
		extra = {
			x_mult = 1,
			Xmult_gain = 0.1
		}
	},

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card:is_suit("Hearts") then
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.Xmult_gain
				return {
					message = 'Upgraded!',
					card = card,
				}
			end
		end

		-- display xmult underneath joker after hand is played
		if context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end

		-- reset mult at the end of a boss blind
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if G.GAME.blind.boss then
				card.ability.extra.x_mult = 1
				return {
					message = localize('k_reset'),
					colour = G.C.RED
				}
			end
		end
	end
}
