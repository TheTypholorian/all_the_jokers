SMODS.Joker {
    name = 'Chip and Dale',
    key = "chipanddale",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.creates,      --1
                card.ability.extra.mini_rounds,  --2
                card.ability.extra.total_rounds, --3
                card.ability.extra.increase      --4
            }
        }
    end,

    rarity = 1,
    cost = 5,
    atlas = 'KHJokers',
    pos = { x = 0, y = 4 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    config = {
        extra = {
            creates = 0,
            mini_rounds = 0,
            total_rounds = 2,
            increase = 1
        }
    },

    calculate = function(self, card, context)
        if context.selling_self then
            local available_slots = G.jokers.config.card_limit - (#G.jokers.cards - 1)
            local to_create = math.min(card.ability.extra.creates, available_slots)
            for i = 1, to_create do
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = 'Uncommon',
                        }
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.mini_rounds = card.ability.extra.mini_rounds + 1


            if card.ability.extra.mini_rounds == card.ability.extra.total_rounds then
                card.ability.extra.creates = card.ability.extra.creates + card.ability.extra.increase
                card.ability.extra.mini_rounds = 0
                return {
                    message = '+1!',
                    colour = G.C.FILTER
                }
            else
                return {
                    message = (card.ability.extra.mini_rounds < card.ability.extra.total_rounds) and
                        (card.ability.extra.mini_rounds .. '/' .. card.ability.extra.total_rounds),
                    colour = G.C.FILTER
                }
            end
        end
    end
}
