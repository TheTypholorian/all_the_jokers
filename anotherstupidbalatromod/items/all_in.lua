SMODS.Voucher {
    key = "all_in",
    loc_txt = {
        name = "All In",
        text = {
            "{C:blue}+1{} Joker slot",
            "{C:blue}+15{} hand size",
            "{C:red}No discards{}"
        }
    },
    atlas = "CustomVouchers", 
    pos = { x = 0, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = true,
    
    redeem = function(self, card)
        local old_joker_limit = G.jokers.config.card_limit
        local old_hand_limit = G.hand.config.card_limit
        local old_discards = G.GAME.round_resets.discards
        
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        
        G.hand.config.card_limit = G.hand.config.card_limit + 15
        
        G.GAME.current_round.discards_left = 0
        G.GAME.round_resets.discards = 0
        
        G.GAME.voucher_all_in_redeemed = true
                
        play_sound('generic1')
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "ALL IN!",
            colour = G.C.RED,
            delay = 0.3
        })
        
        if G.hand then
            G.hand:change_size(-G.hand.config.card_limit + (old_hand_limit + 10))
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and not G.GAME.voucher_all_in_redeemed then
            self:redeem(card)
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
    end,
    
    in_pool = function(self, args)
        if G.GAME and G.GAME.voucher_all_in_redeemed then
            return false, {}
        end
        
        if G.GAME and G.GAME.round and G.GAME.round < 3 then
            return false, {}
        end
        
        return true, {}
    end,
    
    check_for_unlock = function(self, args)
        if args.type == 'voucher_bought' then
            local vouchers_bought = 0
            if G.GAME.vouchers then
                for k, v in pairs(G.GAME.vouchers) do
                    if v then vouchers_bought = vouchers_bought + 1 end
                end
            end
            
            if vouchers_bought >= 3 and G.GAME.round and G.GAME.round >= 4 then
                return true
            end
        end
        
        if args.type == 'joker_added' then
            if #G.jokers.cards >= 5 then
                return true
            end
        end
        
        return false
    end,
    
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Stupid", G.C.RED, G.C.WHITE, 1.1)
    end
}
