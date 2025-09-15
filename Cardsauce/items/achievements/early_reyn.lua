local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "early_reyn" then
            return true
        end
    end,
}

return trophyInfo