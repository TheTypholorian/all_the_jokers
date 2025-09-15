SMODS.Joker{ --Thats not is Misprint
    key = "thatsnotismisprint",
    config = {
        extra = {
            odds = 4,
            mult = 5
        }
    },
    loc_txt = {
        ['name'] = 'Thats not is Misprint',
        ['text'] = {
            [1] = '{C:green}#1# in #2# chance{} {C:red}+15{} Mult',
            [2] = '{C:green}#1# in #2# chance {}to copy abiity from the joker most to the left'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 16
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_shit_thatsnotismisprint') 
        return {vars = {new_numerator, new_denominator}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_8701acf6', 1, card.ability.extra.odds, 'j_shit_thatsnotismisprint', false) then
              SMODS.calculate_effect({mult = card.ability.extra.mult}, card)
          end
            end
        end
    end
}