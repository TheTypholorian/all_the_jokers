
SMODS.Joker {
    key = 'ronengg',
    loc_txt = {
        name = 'RonenGG',
        text = {
            'Only works if no one',
            'he beefed with is present',
            '{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult',
            '{C:green}#4# in #5#{} chance for {X:mult,C:white}X#6#{} Mult',
            '{C:green}#7# in #8#{} chance for {X:mult,C:white}X#9#{} Mult',
            '{C:red}#10# in #11#{} chance for {X:mult,C:white}X#12#{} Mult'
        }
    },
    config = {
        beef_list = {'j_xmpl_tree_forceee', "j_xmpl_amit_shiber", "j_xmpl_forceee_femboy"}, -- jokers he has beef with
        prob_table = {
            {1, 2, 2},    -- 1/2 chance for x2 mult
            {1, 4, 4},    -- 1/4 chance for x4 mult  
            {1, 8, 10},   -- 1/8 chance for x10 mult
            {1, 40, 0.1}  -- 1/40 chance for x0.1 mult
        }
    },
	atlas = 'ronengg',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
    
    loc_vars = function(self, info_queue, center)
        local vars = {}
        local prob_table = (center and center.config and center.config.prob_table) or self.config.prob_table or {
            {1, 2, 2},    -- default values
            {1, 4, 4},    
            {1, 8, 10},   
            {1, 40, 0.1}  
        }
        
        for i, prob in ipairs(prob_table) do
            table.insert(vars, prob[1]) -- numerator
            table.insert(vars, prob[2]) -- denominator  
            table.insert(vars, prob[3]) -- multiplier
        end
        return {vars = vars}
    end,
    
	calculate = function(self, card, context)
		if context.joker_main then
			local beef_list = (card.config.center and card.config.center.config and card.config.center.config.beef_list) or self.config.beef_list
			local prob_table = (card.config.center and card.config.center.config and card.config.center.config.prob_table) or self.config.prob_table
			
			-- בדיקה אם יש Beef
			local has_beef = false
			if beef_list and G.jokers and G.jokers.cards then
				for _, joker in ipairs(G.jokers.cards) do
					if joker ~= card then
						-- debug print: key of the current joker
						print("Checking Joker key:", joker.config.center.key)

						for _, beef_key in ipairs(beef_list) do
							-- debug print: which beef_key is being compared
							print("  Comparing against beef_key:", beef_key)

							if joker.config.center.key == beef_key then
								print("  >> MATCH FOUND! Beef with:", beef_key)
								has_beef = true
								break
							end
						end

						if has_beef then break end
					end
				end
			end

			if not has_beef and prob_table then
				for _, prob_data in ipairs(prob_table) do
					local num, den, mult = prob_data[1], prob_data[2], prob_data[3]

					if pseudorandom('probability_beef_master') < G.GAME.probabilities.normal / den * num then
						return {
							message = 'X' .. mult,
							colour = mult >= 1 and G.C.MULT or G.C.RED,
							Xmult_mod = mult
						}
					end
				end
			elseif has_beef then
				return {
					message = 'I AM ALWAYS RIGHT',
					colour = G.C.RED,
					Xmult_mod = 0
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
        return true
    end,

}