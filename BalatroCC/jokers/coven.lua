-- Coven
SMODS.Joker {
    key = "bccp_coven",
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    rarity = 2, -- Uncommon
    cost = 5,
    atlas = 'ModdedVanilla',
    pos = { x = 2, y = 1 },

    config = { extra = { poker_hand = 'Flush House', applied = false } },

    loc_txt = {
        name = "Coven",
        text = {
            "First {C:attention}Flush House{} played",
            "each round applies a",
            "random {C:dark_edition}edition{} to the",
            "the last card in the hand"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,

    calculate = function(self, card, context)
        
        if not card.ability.extra.applied and context.individual and context.cardarea == G.play and not context.blueprint and context.scoring_name == "Flush House" then
            local last_card = context.scoring_hand[5]
            if last_card and not last_card.edition then 
                card:juice_up(0.3, 0.5)
                local edition = poll_edition('swag money', nil, true, true)
                if edition then
                    last_card:set_edition(edition, true)
                    card.ability.extra.applied = true
                end
            end
        end
    end,

    calculate_joker_reset = function(self, card, context)
        if context.start_of_round then
            card.ability.extra.applied = false
        end
    end
}