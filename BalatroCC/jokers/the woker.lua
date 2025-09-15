-- The Woker
SMODS.Joker {
    key = 'bccp_the_woker',
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    config = { extra = { odds = 6, _woker_triggered = false } },
    rarity = 3, -- Rare
    atlas = 'ModdedVanilla',
    pos = { x = 1, y = 4 },
    cost = 8,

    loc_txt = {
        name = "The Woker",
        text = {
            "{C:green}#1# in #2#{} chance at end of",
            "round to turn a random",
            "Joker {C:dark_edition}Polychrome{}",
            "{C:inactive}stinkyinvegas.com{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        card.ability.extra._numerator, card.ability.extra._denominator =
            SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'the_woker')
        return { vars = { card.ability.extra._numerator, card.ability.extra._denominator } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            -- Only trigger once per round
            if card.ability.extra._woker_triggered then
                return
            end

            -- check chance to trigger
            if not SMODS.pseudorandom_probability(card, 'the_woker', card.ability.extra._numerator, card.ability.extra._denominator) then
                card.ability.extra._woker_triggered = true
                return
            end

            -- gather eligible jokers (exclude self and ones with any edition)
            local editionless_jokers = {}
            for _, j in pairs(G.jokers.cards) do
                if j ~= card and (not j.edition or next(j.edition) == nil) then
                    table.insert(editionless_jokers, j)
                end
            end

            -- pick one random eligible joker
            if #editionless_jokers > 0 then
                local eligible_card = pseudorandom_element(editionless_jokers, 'the_woker')
                if eligible_card then
                    eligible_card:set_edition({ polychrome = true })
                    eligible_card:juice_up(0.3, 0.5)
                    card.ability.extra._woker_triggered = true
                    card:juice_up(0.3, 0.5)
                    return {
                        message = "Gayed!",
                        card = eligible_card
                    }
                end
            end

            -- mark as triggered so it won't run again this round
            card.ability.extra._woker_triggered = true
        end
    end,

    -- Reset trigger for the next round
    post_round = function(self, card)
        card.ability.extra._woker_triggered = false
    end
}
