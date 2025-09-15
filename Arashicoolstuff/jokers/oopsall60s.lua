SMODS.Joker{ --Oops! All 60s
    key = "oopsall60s",
    config = {
        extra = {
            set_probability = 1,
            denominator = 0
        }
    },
    loc_txt = {
        ['name'] = 'Oops! All 60s',
        ['text'] = {
            [1] = 'All {C:attention}listed {}{C:green}probabilities{} are',
            [2] = '{C:attention}guaranteed{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    calculate = function(self, card, context)
        if context.fix_probability  then
        local numerator, denominator = context.numerator, context.denominator
                denominator = card.ability.extra.set_probability
      return {
        numerator = numerator, 
        denominator = denominator
      }
        end
    end
}