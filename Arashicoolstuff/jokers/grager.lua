SMODS.Joker{ --Grager
    key = "grager",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Grager',
        ['text'] = {
            [1] = 'If {C:attention}hand{} contains {C:attention}4 Jacks{}, create',
            [2] = '3 random negative consumables'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (function()
    local rankCount = 0
    for i, c in ipairs(context.scoring_hand) do
        if c:get_id() == 11 then
            rankCount = rankCount + 1
        end
    end
    
    return rankCount >= 4
end)() then
                local created_consumable = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local random_sets = {'Tarot', 'Planet', 'Spectral'}
                        local random_set = random_sets[math.random(1, #random_sets)]
                        SMODS.add_card{set=random_set, edition = 'e_negative', key_append='joker_forge_' .. random_set:lower()}
                        return true
                    end
                }))
                local created_consumable = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local random_sets = {'Tarot', 'Planet', 'Spectral'}
                        local random_set = random_sets[math.random(1, #random_sets)]
                        SMODS.add_card{set=random_set, edition = 'e_negative', key_append='joker_forge_' .. random_set:lower()}
                        return true
                    end
                }))
                local created_consumable = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local random_sets = {'Tarot', 'Planet', 'Spectral'}
                        local random_set = random_sets[math.random(1, #random_sets)]
                        SMODS.add_card{set=random_set, edition = 'e_negative', key_append='joker_forge_' .. random_set:lower()}
                        return true
                    end
                }))
                return {
                    message = created_consumable and localize('k_plus_consumable') or nil,
                    extra = {
                        message = created_consumable and localize('k_plus_consumable') or nil,
                        colour = G.C.PURPLE,
                        extra = {
                            message = created_consumable and localize('k_plus_consumable') or nil,
                            colour = G.C.PURPLE
                        }
                        }
                }
            end
        end
    end
}