SMODS.Joker{ --Gilbert(170 iq)
    key = "gilbert",
    config = {
        extra = {
            planets = 0
        }
    },
    loc_txt = {
        ['name'] = 'Gilbert(170 iq)',
        ['text'] = {
            [1] = 'When hand is played, create a',
            [2] = 'random {C:planet}planet{} card',
            [3] = 'After creating 15, Transform',
            [4] = '{C:attention}[#1#/15]'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.planets}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (card.ability.extra.planets or 0) >= 15 then
                local created_joker = false
    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
        created_joker = true
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                  G.E_MANAGER:add_event(Event({
                      func = function()
                          local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_arashi_supergilb' })
                          if joker_card then
                              
                              
                          end
                          G.GAME.joker_buffer = 0
                          return true
                      end
                  }))
                  end
                return {
                    func = function()
                card:start_dissolve()
                return true
            end,
                    message = "Destroyed!",
                    extra = {
                        message = created_joker and localize('k_plus_joker') or nil,
                        colour = G.C.BLUE
                        }
                }
            else
                local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card{set = 'Planet', key = nil, key_append = 'joker_forge_planet'}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                card.ability.extra.planets = (card.ability.extra.planets) + 1
                return {
                    message = created_consumable and localize('k_plus_planet') or nil
                }
            end
        end
    end
}