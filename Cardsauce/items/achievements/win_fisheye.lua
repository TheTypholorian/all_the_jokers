local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == 'win' then
            if next(SMODS.find_card('j_csau_fisheye')) then
                return true
            end
        end
    end,
}

return trophyInfo