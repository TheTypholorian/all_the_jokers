-- Weighted Die
SMODS.Joker {
    key = "bccp_weighted_dice",
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 1, -- Common
    cost = 4,
    pos = { x = 3, y = 1 },

    loc_txt = {
        name = "Weighted Dice",
        text = {
            "Adds {C:attention}1{} to the numerator",
            "and denominator of",
            "{C:attention}listed{} {C:green}probabilities{}",
            "{C:inactive}(ex:{} {C:green}1 in 2{} {C:inactive}->{} {C:green}2 in 3{}{C:inactive}){}", --fuckass inactive
        }
    },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator + 1,
                denominator = context.denominator + 1
            }
        end
    end
}
