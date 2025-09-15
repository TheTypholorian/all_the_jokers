SMODS.Joker{ --all on red
    key = "allonred",
    config = {
        extra = {
            mod_probability = 1.5,
            mod_probability2 = 1.5,
            denominator = 0
        }
    },
    loc_txt = {
        ['name'] = 'all on red',
        ['text'] = {
            [1] = '{C:attention}Multiply{} all {C:green}Denominators{} by {C:attention}1.5{}',
            [2] = ''
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
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
          if context.mod_probability  then
          local numerator, denominator = context.numerator, context.denominator
                  denominator = denominator / card.ability.extra.mod_probability
                  denominator = denominator * card.ability.extra.mod_probability2
        return {
          numerator = numerator, 
          denominator = denominator
        }
          end
    end
}