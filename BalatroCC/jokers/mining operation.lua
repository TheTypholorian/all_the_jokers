-- Mining Operation
SMODS.Joker {
    key = "bccp_mining_operation",
    blueprint_compat = true,
    rarity = 2, -- uncommon
    cost = 6,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    pos = { x = 1, y = 3 },
    config = { extra = { repetitions = 1, dollars = 1 } },
    loc_txt = {
        name = "Mining Operation",
        text = {
            "{C:attention}Stone{} cards give",
            "{C:money}1${} when scored,",
            "retrigger all",
            "{C:attention}Stone{} cards"
        }
    },
    calculate = function(self, card, context)
        -- ensure defaults
        local extra = card.ability.extra or {}
        local dollars = extra.dollars or 1
        local reps = extra.repetitions or 1

        -- Give $1 when a Stone card is scored
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                return {
                    dollars = dollars
                }
            end
        end

        -- Retrigger Stone cards
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card.ability.name == "Stone Card" then
                return {
                    message = "Again!",
                    repetitions = reps,
                    card = context.other_card
                }
            end
        end
    end
}
