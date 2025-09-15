local trophyInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            local jokers = {
                'j_csau_greyjoker',
                'j_csau_vomitblast',
            }
            return G.FUNCS.have_multiple_jokers(jokers)
        end
    end,
}

return trophyInfo