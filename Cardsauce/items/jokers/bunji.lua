local jokerInfo = {
    name = "Scourge Of Pantsylvania",
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlock_key = 'j_csau_frich',
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.fenix } }
    return { vars = { } }
end

function jokerInfo.check_for_unlock(self, args)
    return G.FUNCS.discovery_check({ mode = 'key', key = self.unlock_key })
end

return jokerInfo