local jokerInfo = {
	name = "Don't Mind If I Do",
	config = {},
	rarity = 2,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gappie } }
	return { vars = { } }
end

function jokerInfo.calculate(self, card, context)
	if context.modify_level_increment then
		if context.hand == "High Card" then
			return {
				message = localize("k_dontmind"),
				colour = G.C.SECONDARY_SET.Planet,
				mult_inc = 2,
			}
		end
	end
end

return jokerInfo