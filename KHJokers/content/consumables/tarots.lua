local function getResourceWithPrefix(prefix)
    local results = {}
    for k, v in pairs(G.P_CENTERS) do
        if k:sub(1, #prefix) == prefix then
            table.insert(results, k)
        end
    end
    return results
end

SMODS.Tarot {
    key = 'awakening',
    set = 'Tarot',
    atlas = "consumabels",
    pos = { x = 0, y = 0 },
    cost = 5,
    discovered = true,

    use = function(self, card, area, copier)
        local used_card = copier or card
        local joker_keys = getResourceWithPrefix("j_kh_")

        for i = #joker_keys, 1, -1 do
            if joker_keys[i] == "j_kh_nobody" or joker_keys[i] == "j_kh_munny" then
                table.remove(joker_keys, i)
            end
        end
        local owned_jokers = {}
        for _, j in ipairs(G.jokers.cards) do
            owned_jokers[j.config.center.key] = true
        end

        local available_jokers = {}
        for _, key in ipairs(joker_keys) do
            if not owned_jokers[key] then
                table.insert(available_jokers, key)
            end
        end

        local random_joker = pseudorandom_element(available_jokers, pseudoseed("KHTarots"))

        if random_joker then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ key = random_joker, set = 'Joker' })
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end

        delay(0.6)
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}
