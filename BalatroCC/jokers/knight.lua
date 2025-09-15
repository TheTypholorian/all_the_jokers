-- Omar
-- if we find a better gameplay loop for omar this joker could be renamed to something related to movement/repositioning
-- maybe knight?
SMODS.Joker {
    key = "bccp_knight",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 2, y = 5 },

    config = { extra = { mult = 12, xmult = 2, hand_count = 0 } },

    loc_txt = {
        name = "Knight",
        text = {
            "1st hand played gives {C:mult}+#1#{} mult",
            "2nd hand played gives {X:mult,C:white}x#2#{} multiplier",
            "then resets to first hand",
            "{C:inactive}(Currently on hand: {C:attention}#3#{}{C:inactive}){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local hand_stage = (card.ability.extra.hand_count % 2) + 1
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.xmult,
                hand_stage
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- Increment hand counter
            card.ability.extra.hand_count = (card.ability.extra.hand_count or 0) + 1

            if card.ability.extra.hand_count == 1 then
                juice_card_until(card, function() return false end, true)
                return {
                    mult = card.ability.extra.mult
                }

            elseif card.ability.extra.hand_count == 2 then
                card.ability.extra.hand_count = 0
                juice_card_until(card, function() return false end, true)
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}
