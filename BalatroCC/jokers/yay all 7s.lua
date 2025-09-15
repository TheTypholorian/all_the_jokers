SMODS.Joker {
    key = 'bccp_yay_all_7s',
    loc_txt = {
        name = "Yay! All 7s",
        text = {
            "{C:green}#1# in #2#{} chance to retrigger",
            "played {C:attention}7's{}", 
            "{C:inactive}(max 2 retriggers){}"
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    config = { extra = { odds = 4 } },
    rarity = 2, -- Uncommon
    atlas = 'ModdedVanilla',
    pos = { x = 4, y = 4 },
    cost = 6,

    loc_vars = function(self, info_queue, card)
        card.ability.extra._numerator, card.ability.extra._denominator =
            SMODS.get_probability_vars(card, 3, card.ability.extra.odds, 'yay_all_7s')
        return { vars = { card.ability.extra._numerator, card.ability.extra._denominator } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            local other = context.other_card
            if other and other:get_id() == 7 then

                local numerator = card.ability.extra._numerator or 3
                local denominator = card.ability.extra._denominator or 4
                local retrigger_count = 0

                if SMODS.pseudorandom_probability(card, 'boe bingus', numerator, denominator) then
                    retrigger_count = retrigger_count + 1
                    if SMODS.pseudorandom_probability(card, 'boe bungus', numerator, denominator) then
                        retrigger_count = retrigger_count + 1
                    end
                end


                if retrigger_count > 0 then
                    return {
                        message = "Again!",
                        repetitions = retrigger_count,
                    }
                end
            end
        end
    end
}


-- might be a bug when paired with thrify joker :/