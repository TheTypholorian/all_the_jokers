SMODS.Atlas({
	key = "the_ox",
	path = "j_the_ox.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_ox",
	atlas = "the_ox",
	pos = {x=0, y=0},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = "no_boss_jokers",
	config = {extra = {destroy = false, hand = "High Card"}},
	loc_vars = function(self, info_queue, card)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			return {key = self.key.."_phantom", vars = {card.ability.extra.hand}}
		else
			add_nemesis_info(info_queue)
			return {key = self.key}
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers() and not G.GAME.pool_flags.no_boss_jokers
	end,
	calculate = function(self, card, context)
		if (context.setting_blind or context.end_of_round) and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			for k, v in pairs(G.GAME.hands) do
				if v.played > G.GAME.hands[card.ability.extra.hand].played then
					card.ability.extra.hand = k
				end
			end
		end
		if context.before and MP.is_pvp_boss() and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			local text,disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
			if text == card.ability.extra.hand then
				ease_dollars(-G.GAME.dollars, true)
				return {
					message = "$0",
					colour = G.C.MONEY
				}
			end
		end
		return destroy_after_pvp(context, card)
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			add_boss_to_deck(card, self.key)
		else
			for k, v in pairs(G.GAME.hands) do
				if v.played > G.GAME.hands[card.ability.extra.hand].played then
					card.ability.extra.hand = k
				end
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and (not card.edition or card.edition.type ~= "mp_phantom") then
			remove_boss_from_deck(self.key)
		end
	end,
	update = function(self, card, dt)
		add_boss_edition(card)
		set_phantom_sprite(card)
	end
})