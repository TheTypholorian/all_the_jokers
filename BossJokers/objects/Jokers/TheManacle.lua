SMODS.Atlas({
	key = "the_manacle",
	path = "j_the_manacle.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_manacle",
	atlas = "the_manacle",
	pos = {x=0, y=0},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = "no_boss_jokers",
	config = {extra = {destroy = false, hands_size = -1}},
	loc_vars = function(self, info_queue, card)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			return {key = self.key.."_phantom", vars = {self.config.extra.hands_size}}
		else
			add_nemesis_info(info_queue)
			return {key = self.key, vars = {self.config.extra.hands_size}}
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers() and not G.GAME.pool_flags.no_boss_jokers
	end,
	calculate = function(self, card, context)
		if context.setting_blind and MP.is_pvp_boss() and card.edition ~= nil and card.edition.type == "mp_phantom" and not context.blueprint then
			G.E_MANAGER:add_event(Event({func = function()
                G.hand:change_size(self.config.extra.hands_size)
            return true end }))
			return {
				message = ""..self.config.extra.hands_size,
				colour = G.C.RED
			}
		end
		return destroy_after_pvp(context, card)
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			add_boss_to_deck(card, self.key)
		elseif MP.is_pvp_boss() then
			G.E_MANAGER:add_event(Event({func = function()
                G.hand:change_size(self.config.extra.hands_size)
            return true end }))
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and (not card.edition or card.edition.type ~= "mp_phantom") then
			remove_boss_from_deck(self.key)
		elseif MP.is_pvp_boss() then
			G.E_MANAGER:add_event(Event({func = function()
				G.hand:change_size(-self.config.extra.hands_size)
			return true end }))
		end
	end,
	update = function(self, card, dt)
		add_boss_edition(card)
		set_phantom_sprite(card)
	end
})