SMODS.Joker {
    key = 'bccp_seasonal_joker',
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    rarity = 2, -- Uncommon
    cost = 6,
    atlas = 'ModdedVanilla',
    pos = { x = 2, y = 4 },

    config = { extra = { triggered_this_round = false } },

    loc_txt = {
        name = "Seasonal Joker",
        text = {
            "Joker changes {C:attention}edition{} at",
            "the end of each round.",
            "Cycles through {C:chips}Foil{}, {C:mult}Holo{},",
            "{X:mult,C:white}Polychrome{}, and {C:dark_edition}Negative{}",
            "editions respectively",
        }
    },
    
    add_to_deck = function(self, card, from_debuff)
        -- Ensure card.edition exists first
        card.edition = card.edition or {}
        -- Only give Foil if no edition is currently set
        if not (card.edition.foil or card.edition.holo or card.edition.polychrome or card.edition.negative) then
            card:set_edition({ foil = true, holo = false, polychrome = false, negative = false })
        end
    end,
    

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            if card.ability.extra.triggered_this_round then
                return
            end
            card.ability.extra.triggered_this_round = true

            -- Cycle through editions using if-elseif-else
            if card.edition.foil then
                card:set_edition({ foil = false, holo = true, polychrome = false, negative = false })
            elseif card.edition.holo then
                card:set_edition({ foil = false, holo = false, polychrome = true, negative = false })
            elseif card.edition.polychrome then
                card:set_edition({ foil = false, holo = false, polychrome = false, negative = true })
            elseif card.edition.negative then
                card:set_edition({ foil = true, holo = false, polychrome = false, negative = false })
            else
                card:set_edition({ foil = true, holo = false, polychrome = false, negative = false })
            end

            card:juice_up(0.3, 0.5)
        end

        if context.setting_blind then
            card.ability.extra.triggered_this_round = false
        end
    end
}
