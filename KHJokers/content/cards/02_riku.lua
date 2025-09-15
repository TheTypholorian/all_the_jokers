SMODS.Joker {
	name = 'Riku',
	key = 'riku',

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.most_played, --1
				card.ability.extra.levels, --2
				card.ability.extra.counter, --3
				card.ability.extra.total --4
			}
		}
	end,

	rarity = 2,
	atlas = "KHJokers",
	pos = { x = 4, y = 1 },
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	config = {
		extra = {
			condition_satisfied = true,
			most_played = 'Pair',
			old_most_played = 'Pair',
			levels = 1,
			counter = 0,
			total = 4
		}
	},

	set_ability = function(self, card, initial, delay_sprites)
		local _handname, _played, _order = 'High Card', -1, 100
		for k, v in pairs(G.GAME.hands) do
			if v.played > _played or (v.played == _played and _order > v.order) then
				_played = v.played
				_handname = k
			end
		end
		card.ability.extra.most_played = _handname
		card.ability.extra.old_most_played = card.ability.extra.most_played
	end,

	calculate = function(self, card, context)
		if context.final_scoring_step or context.end_of_round and not context.individual then
			-- Update most played hand after every hand played/ at end of round
			local _handname, _played, _order = 'High Card', -1, 100
			for k, v in pairs(G.GAME.hands) do
				if v.played > _played or (v.played == _played and _order > v.order) then
					_played = v.played
					_handname = k
				end
			end
			card.ability.extra.old_most_played = card.ability.extra.most_played
			card.ability.extra.most_played = _handname
		end

		if context.reroll_shop then
			card.ability.extra.counter = card.ability.extra.counter + 1

			if card.ability.extra.counter == card.ability.extra.total then
				card.ability.extra.counter = 0 -- resets reroll counter
				local _card = context.blueprint_card or card
				if card.ability.extra.condition_satisfied == true then
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
							local _hand = card.ability.extra.old_most_played
							update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 }, {
								handname = localize(_hand, 'poker_hands'),
								chips = G.GAME.hands[_hand].chips,
								mult = G.GAME.hands[_hand].mult,
								level = G.GAME.hands[_hand].level
							})
							level_up_hand(_card, _hand, nil, card.ability.extra.levels)
							update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, {
								mult = 0, chips = 0, handname = '', level = ''
							})
							return true
						end)
					}))
					card_eval_status_text(_card, 'extra', nil, nil, nil, {
						message = localize('k_level_up_ex'), colour = G.C.FILTER
					})
					return nil, true
				end
			end
		end
	end
}
