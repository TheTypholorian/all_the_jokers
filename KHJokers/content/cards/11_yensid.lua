local function getPokerHand()
	local poker_hands = {}
	local total_weight = 0
	for _, handname in ipairs(G.handlist) do
		if G.GAME.hands[handname].visible then
			local weight = G.GAME.hands[handname].played + 1
			total_weight = total_weight + weight
			poker_hands[#poker_hands + 1] = { handname, total_weight }
		end
	end

	local weight = pseudorandom("yensid") * total_weight
	local hand
	for _, h in ipairs(poker_hands) do
		if weight < h[2] then
			hand = h[1]
			break
		end
	end

	return hand
end


SMODS.Joker {
	name = 'Master Yen Sid',
	key = 'disney',

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.odds,
			'yensid1')
		return {
			vars = {
				numerator, --1
				denominator, --2
			}
		}
	end,

	rarity = 1,
	atlas = 'KHJokers',
	pos = { x = 0, y = 3 },
	cost = 5,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

	config = {
		extra = {
			odds = 2,
			base = 1
		}
	},

	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable and context.consumeable.ability.set == 'Tarot' and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'yensid', card.ability.extra.base, card.ability.extra.odds, 'yensid1') then
				local hand = getPokerHand()
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize("k_level_up_ex"),
					colour = G.C.GREEN,
				})

				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
					handname = localize(hand, "poker_hands"),
					chips = G.GAME.hands[hand].chips,
					mult = G.GAME.hands[hand].mult,
					level = G.GAME.hands[hand].level,
				})

				level_up_hand(card, hand)

				delay(0.1)
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
			end
		end
	end
}
