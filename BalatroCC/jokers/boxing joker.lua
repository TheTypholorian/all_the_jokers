-- Boxing Joker
SMODS.Joker {
    key = "bccp_boxing_joker",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 1, -- Common
    cost = 5,
    pos = { x = 2, y = 0 },

    config = { extra = { chips_1 = 25, chips_2 = 50, chips_3 = 100, hand_count = 0 } },

    loc_txt = {
        name = "Boxing Joker",
        text = {
            "1st hand played gives {C:chips}+#1#{} chips",
            "2nd hand played gives {C:chips}+#2#{} chips",
            "3rd hand played gives {C:chips}+#3#{} chips",
            "then resets to first hand",
            "{C:inactive}(Currently on hand: {C:attention}#4#{}{C:inactive}){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local hand_stage = (card.ability.extra.hand_count % 3) + 1
        return {
            vars = {
                card.ability.extra.chips_1,
                card.ability.extra.chips_2,
                card.ability.extra.chips_3,
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
                    message = "one!",
                    chips = card.ability.extra.chips_1
                }

            elseif card.ability.extra.hand_count == 2 then
                juice_card_until(card, function() return false end, true)
                return {
                    message = "two!",
                    chips = card.ability.extra.chips_2
                }

            elseif card.ability.extra.hand_count == 3 then
                card.ability.extra.hand_count = 0
                juice_card_until(card, function() return false end, true)
                return {
                    message = "punch!",
                    chips = card.ability.extra.chips_3
                }
            end
        end
    end
}