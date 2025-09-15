local trophyInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == "miracle_inherit" then
            return true
        end
    end,
}

return trophyInfo