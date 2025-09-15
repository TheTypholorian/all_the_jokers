local jokerInfo = {
	name = 'Pepperoni Secret',
	config = {
		ach_hands = {}
	},
	rarity = 3,
	cost = 8,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

local function hasPlayedSecret()
	for k, v in pairs(G.handlist) do
		if G.GAME.hands[v].visible and not SMODS.PokerHands[v].visible then
			return true
		end
	end
end

function jokerInfo.in_pool(self, args)
	if hasPlayedSecret() then
		return true
	end
end

function jokerInfo.check_for_unlock(self, args)
	if args.type == "unlock_pep" then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff then	
		if not SMODS.PokerHands[context.scoring_name].visible then
			if not card.ability.ach_hands[context.scoring_name] then card.ability.ach_hands[context.scoring_name] = true end
			local secret = 0 -- tried to get the length of ach_hands but it didnt work for no reason -keku
			for k, v in pairs(card.ability.ach_hands) do secret = secret + 1 end
			if secret >= 3 then check_for_unlock({ type = "three_pepsecret" }) end
			return {
				card = card,
				level_up = true,
				message = localize('k_level_up_ex')
			}
		end
	end
end

return jokerInfo
	
