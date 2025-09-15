SMODS.Atlas({
	key = "blank",
	path = "blank.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "reroll_boss",
	atlas = "blank",
	pos = {x=0, y=0},
	rarity = 1,
	cost = 0,
	no_collection = true,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	config = {extra = {}},
	loc_vars = function(self, info_queue, card)
		
	end,
	in_pool = function(self)
		return false
	end,
	calculate = function(self, card, context)

	end,
	add_to_deck = function(self, card, from_debuff)
		if card.edition ~= nil and card.edition.type == "mp_phantom" then
			reroll_boss_joker(card)
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
			card.ability.mp_sticker_nemesis = false
		end
	end
})