SMODS.Joker {
	name = 'Moogle',
	key = 'moogle',

	loc_vars = function(self, info_queue, card)
		local joker_count = 0
		if G.jokers and G.jokers.cards then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					joker_count = joker_count + 1
				end
			end
		end
		return {
			vars = {
				card.ability.extra.dollars,  --1
				card.ability.extra.dollars * joker_count --2
			}
		}
	end,

	rarity = 1,
	atlas = 'KHJokers',
	pos = { x = 2, y = 4 },
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

	config = {
		extra = {
			dollars = 1
		}
	},

	calc_dollar_bonus = function(self, card)
		local joker_count = 0
		if G.jokers and G.jokers.cards then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					joker_count = joker_count + 1
				end
			end
		end
		return card.ability.extra.dollars * joker_count
	end

}
