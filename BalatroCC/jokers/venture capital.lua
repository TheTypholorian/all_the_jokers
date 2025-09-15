SMODS.Joker {
    key = 'bccp_venture_capital',
    loc_txt = {
        name = "Venture Capital",
        text = {
            "{C:green}#1# in #2# {} chance to gain {C:money}$#3#{}",
            "otherwise lose {C:red}$#4#{} at",
            "end of round"
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    rarity = 2, -- Uncommon
    atlas = 'ModdedVanilla',
    pos = { x = 3, y = 3 },
    cost = 7,
    config = {
        extra = {
            odds = 2,
            payout = 12,
            penalty = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bccp_venture_capital')

        card.ability.extra._numerator = n
        card.ability.extra._denominator = d

        return {
            vars = { n, d, card.ability.extra.payout, card.ability.extra.penalty }
        }
    end,

    calc_dollar_bonus = function(self, card)
        local n = card.ability.extra._numerator or 1
        local d = card.ability.extra._denominator or card.ability.extra.odds

        if SMODS.pseudorandom_probability(card, 'bccp_venture_capital', n, d) then
            return card.ability.extra.payout
        else
            return -card.ability.extra.penalty
        end
    end
}
