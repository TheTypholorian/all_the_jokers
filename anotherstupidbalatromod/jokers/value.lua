SMODS.Joker{ --Value
    key = "value",
    config = {
        extra = {
            sell_value_min = 1,
            sell_value_max = 25
        }
    },
    loc_txt = {
        ['name'] = 'Value',
        ['text'] = {
            [1] = 'Sell value changes from {C:attention}$1-25{} Dollars whean a blind is selected'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 17
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.setting_blind  then
                return {
                    func = function()for i, target_card in ipairs(area.cards) do
                if target_card.set_cost then
            target_joker.ability.extra_value = (card.ability.extra_value or 0) + pseudorandom('sell_value_3c627200', card.ability.extra.sell_value_min, card.ability.extra.sell_value_max)
            target_joker:set_cost()
            end
        end
                    return true
                end,
                    message = "undefined+"..tostring(pseudorandom('sell_value_3c627200', card.ability.extra.sell_value_min, card.ability.extra.sell_value_max)).." Sell Value"
                }
        end
    end
}