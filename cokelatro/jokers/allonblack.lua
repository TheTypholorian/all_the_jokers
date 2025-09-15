SMODS.Joker{ --all on black
    key = "allonblack",
    config = {
        extra = {
            mod_probability = 1.5,
            denominator = 0
        }
    },
    loc_txt = {
        ['name'] = 'all on black',
        ['text'] = {
            [1] = '{C:attention}Divide{} all {C:green}Denominators{} by {C:attention}1.5{}',
            [2] = '{C:inactive}(literally oops! all 6\'s lol){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
          if context.mod_probability and not context.blueprint then
          local numerator, denominator = context.numerator, context.denominator
                  denominator = denominator / card.ability.extra.mod_probability
        return {
          numerator = numerator, 
          denominator = denominator
        }
          end
    end
}