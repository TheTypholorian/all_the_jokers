SMODS.Joker{ --Jackestein
    key = "jackestein",
    config = {
        extra = {
            odds = 4,
            shit_taking = 0
        }
    },
    loc_txt = {
        ['name'] = 'Jackestein',
        ['text'] = {
            [1] = '{C:green}#2# in #3#{} chance for each played {C:orange}Jack{} to create a {C:spectral}Spectral{} card when scored',
            [2] = '{C:inactive}(Must have room){}',
            [3] = '',
            [4] = '{C:hearts}YOUR MULT IS TAKING TOO LONG :){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_shit_jackestein') 
        return {vars = {card.ability.extra.shit_taking, new_numerator, new_denominator}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:get_id() == 11 then
                if SMODS.pseudorandom_probability(card, 'group_0_a88a94e1', 1, card.ability.extra.odds, 'j_shit_jackestein', false) then
              local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card{set = 'Spectral', soulable = undefined, key = nil, key_append = 'joker_forge_spectral'}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                        play_sound("shit_taking")
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_consumable and localize('k_plus_spectral') or nil, colour = G.C.SECONDARY_SET.Spectral})
          end
            end
        end
    end
}