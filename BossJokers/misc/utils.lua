function destroy_after_pvp(context, card)
	if card.edition ~= nil and card.edition.type == "mpbj_boss_edition" and context.end_of_round and MP.is_pvp_boss() and not context.blueprint then
		card.ability.extra.destroy = true
	end
	if context.starting_shop and card.ability.extra.destroy then
		G.E_MANAGER:add_event(Event({func = function()
			play_sound('tarot1')
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
		return {
			message = localize("k_pvp_end"),
			colour = G.C.FILTER
		}
	end
end

function add_boss_joker_info(info_queue)
	info_queue[#info_queue + 1] = {
		set = "Other",
		key = "boss_joker_info"
	}
end

function remove_other_boss_jokers(card)
	local joker_name = {}
	for k, v in pairs(G.jokers.cards) do
		if v ~= card and v.edition ~= nil and v.edition.type == "mpbj_boss_edition" then
			joker_name[#joker_name+1] = v.ability.name
			G.E_MANAGER:add_event(Event({func = function()
				play_sound('tarot1')
				v.T.r = -0.2
				v:juice_up(0.3, 0.4)
				v.states.drag.is = true
				v.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false, func = function()
					G.jokers:remove_card(v)
					v:remove()
					v = nil
					return true; end})) 
				return true
			end}))
		end
	end
	return joker_name
end

function reroll_boss_joker(card)
	local removed_joker = remove_other_boss_jokers(card)
	if removed_joker ~= nil then
		SMODS.remove_pool(BossJokers.BossJokerList, removed_joker[1])
	end
	SMODS.add_card({set = "joker", key = pseudorandom_element(BossJokers.BossJokerList, pseudoseed('reroll'))})
	if removed_joker ~= nil then
		BossJokers.BossJokerList[#BossJokers.BossJokerList] = removed_joker[1]
	end
end

function debuff_suit(debuff, cards, suit)
	for k, v in pairs(cards) do
		if v:is_suit(suit, true) then
			v:set_debuff(debuff)
		end
	end
end

function debuff_face(debuff, cards)
	for k, v in pairs(cards) do
		if v:is_face(true) then
			v:set_debuff(debuff)
		end
	end
end

function debuff_played(debuff, cards)
	for k, v in pairs(cards) do
		if v.ability.played_this_ante then
			v:set_debuff(debuff)
		end
	end
end

function flip(cards, chance, _try_once, _face_only)
	for k, v in pairs(cards) do
		if v.facing == "front" and pseudorandom('flip') <= chance and ((not _face_only) or (_face_only and v:is_face(true))) and not v.ability.tried_flip then
			v:flip()
		end
		v.ability.tried_flip = _try_once
	end
end

function unflip(cards)
	for k, v in pairs(cards) do
		if v.facing == "back" then
			v:flip()
		end
		v.ability.tried_flip = nil
	end
end

function add_boss_to_deck(card, key)
	remove_other_boss_jokers(card)
	MP.ACTIONS.send_phantom(key)
	G.GAME.pool_flags.no_boss_jokers = true
end

function remove_boss_from_deck(key)
	MP.ACTIONS.remove_phantom(key)
	G.GAME.pool_flags.no_boss_jokers = false
end

function add_boss_edition(card)
	if card.edition ~= nil and card.edition.type ~= "mp_phantom" then
		card:set_edition(nil, true, true)
	end
	if card.edition == nil and card.area.config.type ~= "title" then
		card:set_edition("e_mpbj_boss_edition", true, true)
	end
end

function disallow_hand(context, card, disallow)
	for k, v in pairs(context.full_hand) do
		v:set_debuff(disallow)
	end
	for k, v in pairs(G.jokers.cards) do
		v:set_debuff(disallow)
	end
	if disallow then
		G.GAME.hands[context.scoring_name].mult = 0
		G.GAME.hands[context.scoring_name].chips = 0
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function()
				card:juice_up()
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
					play_sound('tarot2', 0.76, 0.4);return true end}))
				play_sound('tarot2', 1, 0.4)
				return true
			end)
		}))
		play_area_status_text(localize("k_not_allowed_ex"))
	else
		G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].s_mult + ((G.GAME.hands[context.scoring_name].level - 1) * G.GAME.hands[context.scoring_name].l_mult)
		G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].s_chips + ((G.GAME.hands[context.scoring_name].level - 1) * G.GAME.hands[context.scoring_name].l_chips)
	end
end

function contains(list, element)
	for i, v in ipairs(list) do
		if v == element then
			return true
		end
	end
	return false
end

function merge(t1, t2)
	for i=1,#t2 do
      t1[#t1+1] = t2[i]
   end
   return t1
end

function have_boss_phantom()
	for i, v in pairs(MP.shared.cards) do
		if string.find(v.ability.name, "mpbj") then
			return true
		end
	end
	return false
end

function enemy_has_boss_jokers()
	if MP.LOBBY.is_host then
		if string.find(MP.LOBBY.guest.hash_str, BossJokers.id) then
			return true
		end
	else
		if string.find(MP.LOBBY.host.hash_str, BossJokers.id) then
			return true
		end
	end
	return false
end

function set_phantom_sprite(card)
	if card.edition ~= nil and card.edition.type == "mp_phantom" then
		card.children.center:set_sprite_pos({x=1,y=0})
	else
		card.children.center:set_sprite_pos({x=0,y=0})
	end
end