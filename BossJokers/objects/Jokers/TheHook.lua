SMODS.Atlas({
	key = "the_hook",
	path = "j_the_hook.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_hook",
	atlas = "the_hook",
	pos = {x=0, y=0},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = "no_boss_jokers",
	config = {extra = {destroy = false, cards = 2}},
	loc_vars = function(self, info_queue, card)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			return {key = self.key.."_phantom", vars = {self.config.extra.cards}}
		else
			add_nemesis_info(info_queue)
			return {key = self.key, vars = {self.config.extra.cards}}
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers() and not G.GAME.pool_flags.no_boss_jokers
	end,
	calculate = function(self, card, context)
		if context.before and MP.is_pvp_boss() and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			local any_selected = nil
			local _cards = {}
			for k, v in ipairs(G.hand.cards) do
				_cards[#_cards+1] = v
			end
			for i = 1, self.config.extra.cards do
				if G.hand.cards[i] then 
					local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
					G.hand:add_to_highlighted(selected_card, true)
					table.remove(_cards, card_key)
					any_selected = true
					play_sound('card1', 1)
				end
			end
			if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
			delay(0.7)
		end
		return destroy_after_pvp(context, card)
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			add_boss_to_deck(card, self.key)
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