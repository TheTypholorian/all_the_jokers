local jokerInfo = {
	name = 'Deathcard',
	config = {
		id = nil,
		times_sold = nil,
		extra = {
			money_mod = 5,
			mult = 4,
			mult_mod = 10
		},
	},
	rarity = 2,
	cost = 2,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
	return { vars = {card.ability.extra.money_mod, card.ability.extra.mult, card.ability.extra.mult_mod} }
end

function jokerInfo.add_to_deck(self, card)
	card:set_cost()
	check_for_unlock({ type = "discover_deathcard" })

	if card.ability.num_sold and to_big(card.ability.num_sold) >= to_big(5) then
		check_for_unlock({ type = "five_deathcard" })
	end

	if not card.ability.id then
		if not G.GAME.csau_unique_deathcards then
			G.GAME.csau_unique_deathcards = (G.GAME.csau_unique_deathcards or 0) + 1
		end
		card.ability.id = G.GAME.csau_unique_deathcards
	else
		-- handles what occurs on copying
		local other_dc = SMODS.find_card('j_csau_deathcard')
		if next(other_dc) then
			for _, v in ipairs(other_dc) do
				if v ~= card and v.ability.id == card.ability.id then
					G.GAME.csau_unique_deathcards = G.GAME.csau_unique_deathcards + 1
					card.ability.id = G.GAME.csau_unique_deathcards
					return
				end
			end
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}},
			colour = G.C.MULT,
			mult_mod = card.ability.extra.mult,
			card = card
		}
	end

	if context.selling_self then
		card.ability.times_sold = (card.ability.times_sold or 0) + 1
		G.GAME.csau_saved_deathcards[#G.GAME.csau_saved_deathcards+1] = {
			key = card.config.center.key,
			id = card.ability.id,
			times_sold = card.ability.times_sold,
			edition = card.edition and 'e_'..card.edition.type or nil
		}
	end
end

return jokerInfo
	