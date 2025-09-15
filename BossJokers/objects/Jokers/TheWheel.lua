SMODS.Atlas({
	key = "the_wheel",
	path = "j_the_wheel.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_wheel",
	atlas = "the_wheel",
	pos = {x=0, y=0},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = "no_boss_jokers",
	config = {extra = {destroy = false, chance = 7}},
	loc_vars = function(self, info_queue, card)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			return {key = self.key.."_phantom", vars = {G.GAME.probabilities.normal, self.config.extra.chance}}
		else
			add_nemesis_info(info_queue)
			return {key = self.key, vars = {self.config.extra.chance}}
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers() and not G.GAME.pool_flags.no_boss_jokers
	end,
	calculate = function(self, card, context)
		if context.hand_drawn and MP.is_pvp_boss() and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			flip(G.hand.cards, G.GAME.probabilities.normal/self.config.extra.chance, true)
		end
		return destroy_after_pvp(context, card)
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			add_boss_to_deck(card, self.key)
		else
			flip(G.hand.cards, G.GAME.probabilities.normal/self.config.extra.chance, true)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and (not card.edition or card.edition.type ~= "mp_phantom") then
			remove_boss_from_deck(self.key)
		else
			unflip(G.hand.cards)
		end
	end,
	update = function(self, card, dt)
		add_boss_edition(card)
		set_phantom_sprite(card)
	end
})