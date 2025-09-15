SMODS.Joker{ --Oops! All 1s
    key = "oopsall1s",
    config = {
        extra = {
            set_probability = 0,
            numerator = 0
        }
    },
    loc_txt = {
        ['name'] = 'Oops! All 1s',
        ['text'] = {
            [1] = 'All {C:attention}listed{} {C:green}probabilities{}',
            [2] = 'are {C:attention}Impossible{}',
            [3] = '{C:inactive}(Example: {C:green}1/3{}{C:inactive} ->{} {C:green}0/3{}{}{C:inactive}){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.fix_probability and not context.blueprint then
        local numerator, denominator = context.numerator, context.denominator
                numerator = card.ability.extra.set_probability
      return {
        numerator = numerator, 
        denominator = denominator
      }
        end
    end
}