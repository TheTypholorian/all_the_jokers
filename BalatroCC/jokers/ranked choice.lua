-- Ranked Choice
SMODS.Joker {
    key = "bccp_ranked_choice",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    pos = { x = 2, y = 3 },
    rarity = 1, -- Common
    cost = 4,
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { 4, 5, card.ability.extra.repetitions } }
    end,
    loc_txt = {
        name = "Ranked Choice",
        text = {
            "Retrigger the {C:attention}4th{} and {C:attention}5th{}",
            "cards played"
        }
    },
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            -- Check if the card being scored is the 4th or 5th card in the hand
            if context.other_card == context.scoring_hand[4] or context.other_card == context.scoring_hand[5] then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
    end
}
