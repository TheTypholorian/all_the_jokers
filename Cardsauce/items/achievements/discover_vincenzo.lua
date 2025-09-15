local trophyInfo = {
    rarity = 3,
    hidden_text = true,
    unlock_key = 'j_csau_vincenzo',
    unlock_condition = function(self, args)
        return G.FUNCS.discovery_check({ mode = 'key', key = self.unlock_key })
    end,
}

return trophyInfo