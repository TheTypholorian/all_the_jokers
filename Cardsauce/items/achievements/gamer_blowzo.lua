local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        return args.type == 'gamer_blowzo'
    end,
}

return trophyInfo