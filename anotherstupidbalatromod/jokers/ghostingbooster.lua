SMODS.Joker{ --Ghosting Booster
    key = "ghostingbooster",
    config = {
        extra = {
            dollars = 4
        }
    },
    loc_txt = {
        ['name'] = 'Ghosting Booster',
        ['text'] = {
            [1] = 'When a {C:attention}Booster Pack{} is Skipped give you {C:money}+4{} Dollars and copys {C:attention}1{} random {C:attention}consumable{} card',
            [2] = 'in your possession',
            [3] = '{C:inactive}(Must have room){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.skipping_booster  then
                return {
                    dollars = card.ability.extra.dollars,
                    extra = {
                        func = function()
            local target_cards = {}
            for i, consumable in ipairs(G.consumeables.cards) do
                table.insert(target_cards, consumable)
            end
            if #target_cards > 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local card_to_copy = pseudorandom_element(target_cards, pseudoseed('copy_consumable'))
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copied_card = copy_card(card_to_copy)
                        copied_card:add_to_deck()
                        G.consumeables:emplace(copied_card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Copied Consumable!", colour = G.C.GREEN})
            end
                    return true
                end,
                        colour = G.C.GREEN
                        }
                }
        end
    end
}