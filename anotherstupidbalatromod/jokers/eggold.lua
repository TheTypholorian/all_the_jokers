SMODS.Joker{ --Eggold
    key = "eggold",
    config = {
        extra = {
            sell_value = 10
        }
    },
    loc_txt = {
        ['name'] = 'Eggold',
        ['text'] = {
            [1] = 'Gains {C:money}$10{} of {C:attention}sell value{} at end of round'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 10,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
                return {
                    func = function()for i, target_card in ipairs(area.cards) do
                if target_card.set_cost then
            target_joker.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.sell_value
            target_joker:set_cost()
            end
        end
                    return true
                end,
                    message = "undefined+"..tostring(card.ability.extra.sell_value).." Sell Value"
                }
        end
    end
}