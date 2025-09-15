-- Public Land / Parks Pass
SMODS.Joker {
    key = "bccp_parks_pass",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 1, -- Common
    cost = 5,
    pos = { x = 4, y = 1 },

    config = { extra = { mult_per_unused = 1, total_mult = 0 } },

    loc_txt = {
        name = "Parks Pass",
        text = {
            "Gain {C:mult}+1{} for every",
            "unused discard this run",
            "{C:inactive}(Currently: {C:mult}+#2#{}{C:inactive}){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local unused = G.GAME.unused_discards or 0
        local total_mult = card.ability.extra.mult_per_unused * unused
        return { vars = { card.ability.extra.mult_per_unused, total_mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local unused = G.GAME.unused_discards or 0
            card.ability.extra.total_mult = card.ability.extra.mult_per_unused * unused
            return { mult = card.ability.extra.total_mult }
        end
    end
}
