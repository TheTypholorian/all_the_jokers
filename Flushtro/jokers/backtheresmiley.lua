SMODS.Joker{ --Back there smiley
    key = "backtheresmiley",
    config = {
        extra = {
            Mult = 15,
            HalfMult = 16,
            odds = 3,
            ignore = 0
        }
    },
    loc_txt = {
        ['name'] = 'Back there smiley',
        ['text'] = {
            [1] = '{X:mult,C:white}+#3#??{} Mult',
            [2] = '{C:inactive,s:0.8}stage 3{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 9,
        y = 1
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
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_flush_backtheresmiley') 
        return {vars = {card.ability.extra.Mult, card.ability.extra.HalfMult, card.ability.extra.ignore, new_numerator, new_denominator}}
    end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                return {
                    mult = card.ability.extra.Mult
                ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_3d3e9ce8', 1, card.ability.extra.odds, 'j_flush_backtheresmiley') then
                      SMODS.calculate_effect({mult = card.ability.extra.HalfMult}, card)
                        SMODS.calculate_effect({mult = card.ability.extra.HalfMult}, card)
                  end
                        return true
                    end
                }
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  then
                return {
                    func = function()
                card:start_dissolve()
                return true
            end,
                    message = "Destroyed!",
                    extra = {
                        func = function()
            local created_joker = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_flush_postawarenessconfusions' })
                    if joker_card then
                        
                        
                    end
                    
                    return true
                end
            }))
            
            if created_joker then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            end
            return true
        end,
                        colour = G.C.BLUE
                        }
                }
        end
    end
}