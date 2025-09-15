-- Exoplanet
SMODS.Joker {
    key = "bccp_exoplanet",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    rarity = 2, -- Uncommon
    cost = 6,
    pos = { x = 4, y = 3 },

    config = { extra = { xmult = 3, poker_hand = 'High Card' } },

    loc_txt = {
        name = "Exoplanet",
        text = {
            "Chooses a random {C:attention}poker hand{}",
            "each hand played. When that",
            "hand is scored gives {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Currently: {C:attention}#2#{C:inactive})"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,

    calculate = function(self, card, context)
        -- Apply X multiplier when the chosen hand is scored
        if context.joker_main and context.scoring_name == card.ability.extra.poker_hand then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        -- After a hand finishes scoring, pick a new random hand
        if context.after and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            if #_poker_hands > 0 then
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'exoplanet')
                return {
                    message = localize('k_reset'),
                    colour = G.C.PURPLE
                }
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        if #_poker_hands > 0 then
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'exoplanet')
        end
    end
}
