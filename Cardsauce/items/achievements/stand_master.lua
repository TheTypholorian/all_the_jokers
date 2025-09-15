local trophyInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            local csauStands = 0
            local csauDiscovered = 0
            for k, v in pairs(SMODS.Centers) do
                if starts_with(k, 'c_csau_') and v.set == 'csau_Stand' then
                    csauStands = csauStands + 1
                    if v.discovered == true then
                        csauDiscovered = csauDiscovered + 1
                    end
                end
            end
            if csauDiscovered == csauStands then
                local stands = 0
                local count = 0
                for k, v in pairs(G.P_CENTERS) do
                    if starts_with(k, 'c_csau_') and v.set == 'csau_Stand' and not v.omit then
                        stands = stands + 1
                        count = count + get_stand_win_sticker(v, true)
                    end
                end
                return count >= (stands*8)
            end
        end
    end,
}

return trophyInfo


