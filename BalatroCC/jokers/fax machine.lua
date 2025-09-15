-- Fax Machine
SMODS.Joker {
    key = "bccp_fax_machine",
    blueprint_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    rarity = 3, -- Rare
    cost = 8,
    pos = { x = 3, y = 4 },
    config = { extra = { destroyed_this_round = false } },
    atlas = 'ModdedVanilla',

    loc_txt = {
        name = "Fax Machine",
        text = {
            "When {C:attention}blind{} is selected,",
            "destroy the Joker to the right",
            "If one was destroyed, then at",
            "end of round create a random",
            "{C:green}Uncommon{} Joker"
        }
    },

    calculate = function(self, card, context)
        -- Reset flag when new blind is picked
        if context.setting_blind and not context.blueprint then
            card.ability.extra.destroyed_this_round = false

            local my_pos
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end

            if my_pos and G.jokers.cards[my_pos + 1]
               and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card)
               and not G.jokers.cards[my_pos + 1].getting_sliced then
                local shredded_card = G.jokers.cards[my_pos + 1]
                shredded_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        shredded_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        play_sound('slice1', 0.96 + math.random() * 0.08)
                        card.ability.extra.destroyed_this_round = true
                        return true
                    end
                }))

                return {
                    message = "Shredded!",
                    colour = G.C.RED,
                }
            end
        end

        -- At the end of round: only create if one was destroyed
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if card.ability.extra.destroyed_this_round
               and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then

                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = 'Uncommon',
                            key_append = 'vremade_fax_machine',
                        }
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))

                return {
                    message = "Fax sent!",
                    colour = G.C.BLUE,
                }
            end
        end
    end
}
