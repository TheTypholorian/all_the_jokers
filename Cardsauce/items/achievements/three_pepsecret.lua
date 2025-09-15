local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "three_pepsecret" then
            return true
        end
    end,
}

return trophyInfo