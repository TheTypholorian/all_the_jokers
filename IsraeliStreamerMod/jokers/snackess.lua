SMODS.Joker {
    key = 'snacksss',
    loc_txt = {
        name = 'Snacksss',
        text = {
            'Every hand, {C:attention}1/4{} chance',
            'to create {C:attention}Live{}',
            'If Live is created, gain {C:money}$25-100{}',
            'If Live is created, {C:attention}1/4{} chance',
            'to delete a card (Twitch is antisemitic)'
        }
    },
    config = { 
        extra = {
            live_chance = 0.25, -- 1/4 chance to create live
            delete_chance = 0.25, -- 1/4 chance to delete card if live is created
            min_money = 25,
            max_money = 100
        }
    },
    atlas = 'snacksss',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },

    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.live_chance * 100, center.ability.extra.min_money, center.ability.extra.max_money, center.ability.extra.delete_chance * 100}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local live_chance = (card.ability and card.ability.extra and card.ability.extra.live_chance) or self.config.extra.live_chance
            local delete_chance = (card.ability and card.ability.extra and card.ability.extra.delete_chance) or self.config.extra.delete_chance
            local min_money = (card.ability and card.ability.extra and card.ability.extra.min_money) or self.config.extra.min_money
            local max_money = (card.ability and card.ability.extra and card.ability.extra.max_money) or self.config.extra.max_money
            
            -- Check if Live is created (1/4 chance)
            if pseudorandom('snackess_live') < G.GAME.probabilities.normal * live_chance then
                -- Live is created! Give money
                local money_gained = math.random(min_money, max_money)
                G.GAME.dollars = G.GAME.dollars + money_gained
                
                -- Check if we should delete a card (1/4 chance)
                if pseudorandom('snackess_delete') < G.GAME.probabilities.normal * delete_chance then
                    -- Delete a random card from hand
                    if G.hand and G.hand.cards and #G.hand.cards > 0 then
                        local random_index = math.random(1, #G.hand.cards)
                        
                        -- Delete Snackess itself (got banned by Twitch)
                        card:start_dissolve()
                        --card:remove_from_deck()
                        G.jokers:remove_card(card)
                        --card:remove()
                        
                        return {
                            message = 'Live! +$' .. money_gained .. ' (BANNED!)',
                            colour = G.C.RED,
                            card = card
                        }
                    else
                        return {
                            message = 'Live! +$' .. money_gained .. ' (No cards to delete)',
                            colour = G.C.MONEY,
                            card = card
                        }
                    end
                else
                    return {
                        message = 'Live! +$' .. money_gained,
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}
