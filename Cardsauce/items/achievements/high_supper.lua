local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "high_supper" then
            return true
        end
    end,
}

return trophyInfo