SMODS.Joker {
    key = 'smammit',
    loc_txt = {
        name = 'Smammit',
        text = {
            'If you have a {C:banana}Banana{} in your',
            'joker deck, eat it and gain {C:money}$10{}',
            '{C:attention}Paired greatly with Forceee{}'
        }
    },
    config = { 
        extra = {
            money_gain = 10, -- Money gained for eating banana
            banana_key = 'j_gros_michel' -- Key for the banana joker
        }
    },
    atlas = 'smammit',
    rarity = 1, -- Common
    cost = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    shop_rate = 99, --rate in shop out of 100

    pos = { x = 0, y = 0 },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.money_gain}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local money_gain = (card.ability and card.ability.extra and card.ability.extra.money_gain) or self.config.extra.money_gain
            local banana_key = (card.ability and card.ability.extra and card.ability.extra.banana_key) or self.config.extra.banana_key
            
            -- Check if there's a banana in the joker deck
            local banana_found = nil
            if G.jokers and G.jokers.cards then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker ~= card and joker.config.center.key == banana_key then
                        banana_found = joker
                        break
                    end
                end
            end
            
            -- If banana found, eat it and give money
            if banana_found then
                -- Remove the banana from the joker deck
                banana_found:start_dissolve()
                G.jokers:remove_card(banana_found)
                banana_found:remove_from_deck()
                --banana_found:remove()
                -- Give money
                G.GAME.dollars = G.GAME.dollars + money_gain
                
                return {
                    message = 'Banana eaten! +$' .. money_gain,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end,
    
    in_pool = function(self, wawa, wawa2)
        return true
    end
}
