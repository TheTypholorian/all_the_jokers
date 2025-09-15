SMODS.Joker {
    key = 'bigi',
    loc_txt = {
        name = 'Bigi',
        text = {
            'Every hand, randomly eats one',
            'played card and gives mult:',
            '{C:attention}A,J,Q,K{}: {X:mult,C:white}X3{} Mult',
            '{C:attention}6,7,8,9,10{}: {X:mult,C:white}X2{} Mult', 
            '{C:attention}2,3,4,5{}: {X:mult,C:white}X1.5{} Mult'
        }
    },
    config = { 
        extra = {
            high_mult = 3,
            mid_mult = 2,
            low_mult = 1.5
        }
    },
    atlas = 'bigi',
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
    
    loc_vars = function(self, info_queue, center)
        if not center or not center.ability or not center.ability.extra then
            return {vars = {self.config.extra.high_mult, self.config.extra.mid_mult, self.config.extra.low_mult}}
        end
        return {vars = {center.ability.extra.high_mult, center.ability.extra.mid_mult, center.ability.extra.low_mult}}
    end,
    
    calculate = function(self, card, context)
        if not card.ability or not card.ability.extra then 
            return 
        end
        
        local high_mult = card.ability.extra.high_mult or self.config.extra.high_mult
        local mid_mult = card.ability.extra.mid_mult or self.config.extra.mid_mult  
        local low_mult = card.ability.extra.low_mult or self.config.extra.low_mult
    
        
        if context and context.joker_main then
            if G.play and G.play.cards and #G.play.cards > 0 then
                local random_index = math.random(1, #G.play.cards)
                local eaten_card = G.play.cards[random_index]
                
                if eaten_card and eaten_card.base and eaten_card.base.value then
                    local card_value = eaten_card.base.value
                    local mult_value = low_mult
                    
                    if card_value == 'Ace' or card_value == 'Jack' or card_value == 'Queen' or card_value == 'King' then
                        mult_value = high_mult
                    elseif card_value == '6' or card_value == '7' or card_value == '8' or card_value == '9' or card_value == '10' then
                        mult_value = mid_mult
                    elseif card_value == '2' or card_value == '3' or card_value == '4' or card_value == '5' then
                        mult_value = low_mult
                    end

                    eaten_card:start_dissolve()
                    eaten_card:remove_from_deck()
                    G.play:remove_card(eaten_card)

                    --eaten_card:remove()
                    
                    return {
                        x_mult = mult_value,
                        card = card
                    }
                end
            end
        end
        
        if context and context.after and context.cardarea == G.play and G.play and G.play.cards and #G.play.cards > 0 then
            local random_index = pseudorandom('bigi_random_eat', 1, #G.play.cards)
            local eaten_card = G.play.cards[random_index]
            
            if eaten_card and eaten_card.base and eaten_card.base.value then
                local card_value = eaten_card.base.value
                local mult_value = low_mult
                
                if card_value == 'Ace' or card_value == 'Jack' or card_value == 'Queen' or card_value == 'King' then
                    mult_value = high_mult
                elseif card_value == '6' or card_value == '7' or card_value == '8' or card_value == '9' or card_value == '10' then
                    mult_value = mid_mult
                elseif card_value == '2' or card_value == '3' or card_value == '4' or card_value == '5' then
                    mult_value = low_mult
                end

                eaten_card:start_dissolve()
                eaten_card:remove_from_deck()
                G.play:remove_card(eaten_card)
                
                return {
                    x_mult = mult_value,
                    card = card
                }
            end
        end
    end,
    
    in_pool = function(self)
        return true
    end
}
