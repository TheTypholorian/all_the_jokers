SMODS.Atlas({
	key = "the_tooth",
	path = "j_the_tooth.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_tooth",
	atlas = "the_tooth",
	pos = {x=0, y=0},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = "no_boss_jokers",
	config = {extra = {destroy = false, money = 1}},
	loc_vars = function(self, info_queue, card)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			return {key = self.key.."_phantom", vars = {self.config.extra.money}}
		else
			add_nemesis_info(info_queue)
			return {key = self.key, vars = {self.config.extra.money}}
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers() and not G.GAME.pool_flags.no_boss_jokers
	end,
	calculate = function(self, card, context)
		if context.before and MP.is_pvp_boss() and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			for k, v in pairs(context.full_hand) do
				G.E_MANAGER:add_event(Event({func = function() v:juice_up(); return true end }))
				ease_dollars(-self.config.extra.money)
				delay(0.23)
			end
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