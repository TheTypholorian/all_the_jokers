


SMODS.Joker{
    key = 'tree_forceee',
    loc_txt = {
        name = 'Tree Forceee',
        text = {
            'When Blind is selected,',
            'there is a {C:attention}50%{} chance',
            'to create a {C:banana}Banana{} with +15 Mult',
            '(This joker ignore the max joker slots)'
        },
    },
    config = { 
        extra = {
            Xmult = 15
        }
    },
	atlas = 'tree_force',
    rarity = 2, 
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
	
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if math.random() < 0.5 then
                local banana = create_card(
                    'Joker', 
                    G.jokers,    
                    nil, nil, nil, nil, 
                    'j_gros_michel')
                if banana then
                    banana:add_to_deck()
                    G.jokers:emplace(banana)
                else
                    print("Error: Gros Michel joker not found!")
                end
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end,
}
