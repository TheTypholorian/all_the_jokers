SMODS.Joker {
    key = 'odedsvr',
    loc_txt = {
        name = 'OdedSVR',
        text = {
            'Gives {C:money}$6{} at Cash Out',
            'If paired with {C:attention}Snackess{},',
            'gives {C:money}$20{} at Cash Out instead',
            '{C:red}Doesn\'t work with Forceee{}'
        }
    },
    config = { 
        extra = {
            base_money = 6,
            paired_money = 20,
            incompatible_jokers = {'j_xmpl_tree_forceee'} -- jokers that disable this effect
        }
    },
    atlas = 'odedsvr',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },

    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.base_money, center.ability.extra.paired_money}}
    end,
    
    calc_dollar_bonus = function(self, card)
        local incompatible_list = (card.ability and card.ability.extra and card.ability.extra.incompatible_jokers) or self.config.extra.incompatible_jokers
        local base_money = (card.ability and card.ability.extra and card.ability.extra.base_money) or self.config.extra.base_money
        local paired_money = (card.ability and card.ability.extra and card.ability.extra.paired_money) or self.config.extra.paired_money
        
        -- Check if incompatible jokers are present
        local has_incompatible = false
        if incompatible_list and G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= card then
                    for _, incompatible_key in ipairs(incompatible_list) do
                        if joker.config.center.key == incompatible_key then
                            has_incompatible = true
                            break
                        end
                    end
                    if has_incompatible then break end
                end
            end
        end
        
        -- If incompatible joker is present, don't give money
        if has_incompatible then
            return 0
        end
        
        -- Check if Snackess is present
        local has_snackess = false
        if G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= card and joker.config.center.key == 'j_xmpl_snackess' then
                    has_snackess = true
                    break
                end
            end
        end
        
        -- Return money based on whether Snackess is present
        return has_snackess and paired_money or base_money
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}
