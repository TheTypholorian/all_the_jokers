local trophyInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "activate_red" then
            return true
        end
    end,
}

return trophyInfo