SMODS.Seal {
    key = 'ultyseal',
    pos = { x = 4, y = 0 },
    badge_colour = HEX('5c4dfe'),
   loc_txt = {
        name = 'Ulty Seal',
        label = 'Ulty Seal',
        text = {
        [1] = 'When this card is discard create a random {C:tarot}Ultrarot{} card',
        [2] = '{C:inactive}(Must have room){}'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            return { func = function()local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card{set = 'ultrarot', key_append = 'enhanced_card_ultrarot'}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                    if created_consumable then
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Consumable!", colour = G.C.PURPLE})
                    end
                    return true
                end }
        end
    end
}