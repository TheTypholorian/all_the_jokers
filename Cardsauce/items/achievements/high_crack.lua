local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_thisiscrack')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if to_big(v.ability.extra.x_mult) >= to_big(4) then
                    return true
                end
            end
        end
    end,
}

return trophyInfo