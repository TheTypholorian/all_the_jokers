SMODS.Joker {
    key = 'odedsvr_odelyn',
    rarity = 2, -- Uncommon
    unlocked = true,
    discovered = true,
    cost = 5,
    pos = {x = 0, y = 0},
    atlas = 'oded_odelyn',
    config = {
        extra = { used = false }
    },

    loc_txt = {
        name = 'OdedSVR Odelyn',
        text = {
            "After 1 round, Server died",
            "But you made {C:money}$100{}"
        }
    },

    -- אחרי round
    calculate = function(self, card, context)
        if context.end_of_round and not card.ability.extra.used then
            card.ability.extra.used = true
            ease_dollars(100) -- מוסיף כסף לשחקן
            card:start_dissolve() -- אפקט העלמות NEED TO ADD TO Other thing that remove_card
            G.jokers:remove_card(card) -- מוחק מהשולחן
            return {
                message = "$100!",
                colour = G.C.MONEY
            }
        end
    end
}
