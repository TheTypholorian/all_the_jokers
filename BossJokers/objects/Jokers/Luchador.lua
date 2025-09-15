SMODS.Atlas({
	key = "luchador",
	path = "j_luchador.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "luchador",
	atlas = "luchador",
	pos = {x=0, y=0},
	rarity = 2,
	cost = 5,
	no_collection = true,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	config = {extra = {}, mp_sticker_balanced = true},
	loc_vars = function(self, info_queue, card)
		
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers()
	end,
	calculate = function(self, card, context)
		if context.selling_self and have_boss_phantom() then
			MP.ACTIONS.send_phantom(self.key)
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			remove_other_boss_jokers(card)
			G.E_MANAGER:add_event(Event({func = function()
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false, func = function()
					G.jokers:remove_card(card)
					card:remove()
					card = nil
					return true; end})) 
				return true
			end}))
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		
	end,
	update = function (self, card, dt)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			card.ability.mp_sticker_balanced = false
			card.ability.mp_sticker_nemesis = false
		end
		set_phantom_sprite(card)
	end
})