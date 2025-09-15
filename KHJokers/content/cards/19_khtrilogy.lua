local function randomPokerHand(card)
	local _poker_hands = {}
	for handname, _ in pairs(G.GAME.hands) do
		if SMODS.is_poker_hand_visible(handname) and handname ~= 'Five of a Kind' and handname ~= 'Flush Five' and handname ~= 'Flush House' then
			_poker_hands[#_poker_hands + 1] = handname
		end
	end

	card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'kh_poker_hand' .. (card.round or 0))
end

SMODS.Joker {
	name = 'Kingdom Hearts',
	key = "khtrilogy",

	loc_vars = function(self, info_queue, card)
		return {
			key = self.key .. '_kh' .. tostring(card.ability.extra.level),
			vars = {
				card.ability.extra.mult, --1
				card.ability.extra.xmult, --2
				card.ability.extra.counter, --3
				card.ability.extra.total, --4
				card.ability.extra.chips, --5
				card.ability.extra.poker_hand, --6
			}
		}
	end,


	rarity = 2,
	atlas = 'KHJokers',
	pos = { x = 2, y = 3 },
	cost = 6,
	unlocked = true,
	discovered = true,
	eternal_compat = true,
	perishable_compat = true,
	blueprint_compat = true,

	config = {
		extra = {
			chips = 100,
			mult = 25,
			xmult = 3,
			counter = 0,
			total = 1,
			level = 1,
			pos_override = { x = 2, y = 3 },
			poker_hand = 'Flush',
			hand_played = false,
		},
	},

	load = function(self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event({
			func = function()
				card.children.center:set_sprite_pos(card.ability.extra.pos_override)
				return true
			end
		}))
	end,

	set_ability = function(self, card, initial, delay_sprites)
		randomPokerHand(card)
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local level = {
				[1] = { chips = card.ability.extra.chips },
				[2] = { mult = card.ability.extra.mult },
				[3] = { xmult = card.ability.extra.xmult },
			}
			return level[card.ability.extra.level]
		end

		if context.end_of_round and not context.blueprint and card.ability.extra.level == 2 then
			card.ability.extra.hand_played = false
			randomPokerHand(card)
		end

		if context.before and next(context.poker_hands[card.ability.extra.poker_hand]) and card.ability.extra.level == 2 then
			card.ability.extra.hand_played = true
		end

		if context.after and not context.blueprint and not context.repetition and not context.other_card then
			local hand_score = hand_chips * mult
			local blind_score = G.GAME.blind.chips * 2
			local level = card.ability.extra.level

			if level == 1 then
				if hand_score >= blind_score then
					card.ability.extra.counter = card.ability.extra.counter + 1
				end
			elseif level == 2 then
				if card.ability.extra.hand_played then
					card.ability.extra.counter = card.ability.extra.counter + 1
					card_eval_status_text(card, "extra", nil, nil, nil, {
						message = card.ability.extra.counter .. '/' .. card.ability.extra.total,
						colour = G.C.FILTER,
					})
					card.ability.extra.hand_played = false
				end
			end
			if card.ability.extra.counter >= card.ability.extra.total and card.ability.extra.level < 3 then
				card.ability.extra.counter = 0
				card.ability.extra.total = card.ability.extra.total + 2 --makes total 3
				card.ability.extra.level = card.ability.extra.level + 1 -- upgrades joker

				G.E_MANAGER:add_event(Event({
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								card:juice_up(1, 0.5)
								card.ability.extra.pos_override.x = card.ability.extra.level + 1
								card.children.center:set_sprite_pos(card.ability.extra.pos_override)
								return true
							end
						}))
						SMODS.calculate_effect({ message = localize('k_upgrade_ex'), colour = G.C.FILTER }, card)
						return true
					end
				}))
				return
			end
		end
	end
}
