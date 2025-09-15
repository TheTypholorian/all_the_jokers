local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "hand_level" then
            if next(SMODS.find_card('j_csau_pivot')) or next(SMODS.find_card('j_csau_dontmind')) then
                if args.hand == "High Card" and to_big(args.level) < to_big(20) and to_big(args.level_after) >= to_big(20) then
                    return true
                end
            end
        end
    end,
}

return trophyInfo