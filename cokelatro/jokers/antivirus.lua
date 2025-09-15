SMODS.Joker{ --Anti Virus
    key = "antivirus",
    config = {
        extra = {
            Rounds = 0,
            var1 = 0,
            virus = 0,
            eternal = 0,
            ignore = 0
        }
    },
    loc_txt = {
        ['name'] = 'Anti Virus',
        ['text'] = {
            [1] = 'Prevents {C:planet}Malwares{} created by {C:attention}virus{} joker',
            [2] = 'for 5 {C:attention}rounds{}, afterward, becomes {C:planet}malware{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
            
          or args.source == 'sho' or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and G.GAME.pool_flags.cokelatr_ANTI
      end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            if (card.ability.extra.var1 or 0) >= 5 then
                G.GAME.pool_flags.cokelatr_virus = false
                return {
                    func = function()
                card:undefined()
                return true
            end,
                    extra = {
                        func = function()
            local created_joker = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_cokelatr_malware' })
                    if joker_card then
                        
                        joker_card:add_sticker('eternal', true)
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
            else
                return {
                    func = function()
                    card.ability.extra.Rounds = (card.ability.extra.Rounds) + 1
                    return true
                end
                }
            end
        end
        if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers  and not context.blueprint then
                G.GAME.pool_flags.cokelatr_virus = false
        end
        if context.selling_self  and not context.blueprint then
                G.GAME.pool_flags.cokelatr_virus = true
        end
    end
}