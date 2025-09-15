SMODS.Joker {
    key = 'zagron',
    loc_txt = {
        name = 'Zagron',
        text = {
            'At Cash Out, gain {C:money}$10{}',
            'At start of round, {C:attention}1/2{} chance',
            'to take {C:money}$8{} for weed'
        }
    },
    config = { 
        extra = {
            bituah_money = 10, -- Bituah Leumi money at Cash Out
            weed_cost = 8, -- Cost for weed
            weed_chance = 0.5 -- 1/2 chance to take money for weed
        }
    },
    atlas = 'zagron',
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.bituah_money, center.ability.extra.weed_chance * 100, center.ability.extra.weed_cost}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind then
            local weed_chance = (card.ability and card.ability.extra and card.ability.extra.weed_chance) or self.config.extra.weed_chance
            local weed_cost = (card.ability and card.ability.extra and card.ability.extra.weed_cost) or self.config.extra.weed_cost
            -- Check if we should take money for weed (1/2 chance)
            if pseudorandom('zagron_weed') < G.GAME.probabilities.normal * weed_chance then
                G.GAME.dollars = G.GAME.dollars - weed_cost
                
                return {
                    message = '-$' .. weed_cost .. ' (Weed)',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end,
    
    calc_dollar_bonus = function(self, card)
        local bituah_money = (card.ability and card.ability.extra and card.ability.extra.bituah_money) or self.config.extra.bituah_money
        return bituah_money
    end,
    
    in_pool = function(self, wawa, wawa2)
        return true
    end
}
