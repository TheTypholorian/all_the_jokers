local trophyInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            local jokers1 = {
                'j_csau_powers',
                'j_oops',
            }
            local jokers2 = {
                'j_csau_powers',
                'j_csau_beginners',
            }
            return (G.FUNCS.have_multiple_jokers(jokers1) or G.FUNCS.have_multiple_jokers(jokers2))
        end
    end,
}

return trophyInfo