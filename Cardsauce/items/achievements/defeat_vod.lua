local trophyInfo = {
    rarity = 2,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "defeat_vod" then
            return true
        end
    end,
}

return trophyInfo