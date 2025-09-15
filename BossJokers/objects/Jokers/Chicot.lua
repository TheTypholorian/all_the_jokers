SMODS.Atlas({
	key = "chicot",
	path = "j_chicot.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "chicot",
	atlas = "chicot",
	pos = {x=0, y=0},
    soul_pos = {x=1, y=0},
	rarity = 4,
	cost = 20,
	no_collection = true,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	config = {extra = {sent_phantom = false}, mp_sticker_balanced = true},
	loc_vars = function(self, info_queue, card)
		
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers and enemy_has_boss_jokers()
	end,
	calculate = function(self, card, context)
		if (not card.ability.extra.sent_phantom) and MP.is_pvp_boss() and have_boss_phantom() then
			MP.ACTIONS.send_phantom("j_mpbj_luchador")
            card.ability.extra.sent_phantom = true
		end
        if card.ability.extra.sent_phantom and not have_boss_phantom() then
            card.ability.extra.sent_phantom = false
        end
	end,
	add_to_deck = function(self, card, from_debuff)
		if MP.is_pvp_boss() and have_boss_phantom() then
			MP.ACTIONS.send_phantom("j_mpbj_luchador")
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		
	end
})