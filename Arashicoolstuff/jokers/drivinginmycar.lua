SMODS.Joker{ --Driving in my car
    key = "drivinginmycar",
    config = {
        extra = {
            var1 = 0
        }
    },
    loc_txt = {
        ['name'] = 'Driving in my car',
        ['text'] = {
            [1] = 'Right after a beer',
            [2] = 'hey that bump is shaped like a deer',
            [3] = 'DUI? How about you die',
            [4] = 'I\'ll go a hundred miles an hour',
            [5] = 'Little did you know i filled up on gas',
            [6] = 'Ima get your fountain-making ass',
            [7] = 'Pulverise this F#ck with my bergentrück',
            [8] = 'It seems your out of luck',
            [9] = '{E:1}{s:1.5}TRUCK{}{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                local created_joker = false
    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
        created_joker = true
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                  G.E_MANAGER:add_event(Event({
                      func = function()
                          local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_arashi_deer' })
                          if joker_card then
                              
                              
                          end
                          G.GAME.joker_buffer = 0
                          return true
                      end
                  }))
                  end
                return {
                    message = created_joker and localize('k_plus_joker') or nil
                }
        end
        if context.pre_discard  then
                return {
                    func = function()
                local target_joker = nil
                for i, joker in ipairs(G.jokers.cards) do
                    if joker.config.center.key == "j_arashi_deer" and not joker.ability.eternal and not joker.getting_sliced then
                        target_joker = joker
                        break
                    end
                end
                
                if target_joker then
                    target_joker.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target_joker:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Destroyed!", colour = G.C.RED})
                end
                    return true
                end
                }
        end
    end
}