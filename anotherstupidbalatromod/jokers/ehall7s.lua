SMODS.Joker{ --Eh All 7s?
    key = "ehall7s",
    config = {
        extra = {
            mod_probability = 3,
            numerator = 0
        }
    },
    loc_txt = {
        ['name'] = 'Eh All 7s?',
        ['text'] = {
            [1] = 'Triples all {C:attention}listed{} {C:green}probabilities{}',
            [2] = '(ex: {C:green}1 in 3{} -> {C:green}3 in 3{})'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
          if context.mod_probability and not context.blueprint then
          local numerator, denominator = context.numerator, context.denominator
                  numerator = numerator * card.ability.extra.mod_probability
        return {
          numerator = numerator, 
          denominator = denominator
        }
          end
    end
}