SMODS.Joker{ --Distraught
    key = "distraught",
    config = {
        extra = {
            Interval = 0.1,
            ExpMult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Distraught',
        ['text'] = {
            [1] = 'Gains {X:mult,C:white}^#1#{} Mult for',
            [2] = 'every card {C:attention}sold{} or {C:attention}destroyed{}',
            [3] = '{C:inactive}(Currently{} {X:mult,C:white}^#2#{} {C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 4
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
    soul_pos = {
        x = 6,
        y = 4
    },
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Interval, card.ability.extra.ExpMult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    e_mult = card.ability.extra.ExpMult
                }
        end
        if context.selling_card  then
                return {
                    func = function()
                    card.ability.extra.ExpMult = (card.ability.extra.ExpMult) + card.ability.extra.Interval
                    return true
                end,
                    message = "Upgrade"
                }
        end
        if context.remove_playing_cards  then
                return {
                    func = function()
                    card.ability.extra.ExpMult = (card.ability.extra.ExpMult) + card.ability.extra.Interval
                    return true
                end,
                    message = "Upgrade"
                }
        end
    end
}