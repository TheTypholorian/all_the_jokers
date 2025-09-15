SMODS.Seal {
    key = 'graveseal',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            odds = 8
        }
    },
    badge_colour = HEX('000000'),
   loc_txt = {
        name = 'Grave Seal',
        label = 'Grave Seal',
        text = {
        [1] = 'When this card is discarded,',
        [2] = '{C:green} #1# in 8{} chance to create',
        [3] = 'a random {C:rare}Rare{} Joker',
        [4] = '{C:inactive}(Must have room){}'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.seal.extra.odds, 'fearspho_graveseal')
        return {vars = {numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            if SMODS.pseudorandom_probability(card, 'group_0_acfd8773', 1, card.ability.seal.extra.odds, 'm_fearspho') then
                local created_joker = false
                if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                    created_joker = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Rare' })
                        if joker_card then
                            
                            
                        end
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_joker and localize('k_plus_joker') or nil, colour = G.C.BLUE})
            end
        end
    end
}