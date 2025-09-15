-- Fire Starter
SMODS.Joker {
    key = "bccp_lighter",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 0, y = 3 },

    config = { extra = { chip_gain = 7, chips = 0 } },

    loc_txt = {
        name = "Lighter",
        text = {
            "Gains {C:chips}+#1#{} permanent chips",
            "whenever a card is {C:attention}sold{}",
            "Currently gives {C:chips}+#2#{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        -- Selling a card: increase chips
        if context.selling_card and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end

        -- Apply bonus chips during scoring
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}
