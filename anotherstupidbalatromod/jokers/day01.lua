SMODS.Joker{ --Day 0
    key = "day01",
    config = {
        extra = {
            monoxide = -2,
            mult = 5,
            sell_value = 2
        }
    },
    loc_txt = {
        ['name'] = 'Day 0',
        ['text'] = {
            [1] = 'Minecraft hardcore buy i have carbon monoxide poisoning'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "shit_shitpost",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                for i, target_card in ipairs(area.cards) do
                if target_card.set_cost then
            target_joker.ability.extra_value = math.max(0, (card.ability.extra_value or 0) - card.ability.extra.sell_value)
            target_joker:set_cost()
            end
        end
                return {
                    mult = card.ability.extra.mult,
                    extra = {
                        message = "undefined-"..tostring(card.ability.extra.sell_value).." Sell Value",
                        colour = G.C.MONEY
                        }
                }
        end
        if context.after and context.cardarea == G.jokers  then
                return {
                    func = function()
            local created_joker = false
    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
        created_joker = true
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_shit_day02' })
                    if joker_card then
                        
                        
                    end
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
            end
            if created_joker then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            end
            return true
        end,
                    extra = {
                        func = function()
                card:undefined()
                return true
            end,
                        colour = G.C.RED
                        }
                }
        end
    end
}