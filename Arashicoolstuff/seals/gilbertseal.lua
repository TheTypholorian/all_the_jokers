SMODS.Seal {
    key = 'gilbertseal',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            retrigger_times = 15,
            x_mult = 1.2,
            odds = 7
        }
    },
    badge_colour = HEX('87CEEB'),
   loc_txt = {
        name = 'Gilbert seal',
        label = 'Gilbert seal',
        text = {
        [1] = 'Retriggers card 15 times',
        [2] = 'Each trigger gives {X:mult,C:white}1.2{} Mult',
        [3] = '{C:green}#1#{} in {C:green}#2#{} chance to be {C:attention}destroyed{}',
        [4] = 'when scored'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.seal.extra.odds, 'arashi_gilbertseal')
        return {vars = {numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and card.should_destroy then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_dissolve()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Card Destroyed!", colour = G.C.RED})
            return
        end
        if context.repetition and card.should_retrigger then
            return { repetitions = card.ability.seal.extra.retrigger_times }
        end
        if context.main_scoring and context.cardarea == G.play then
            card.should_retrigger = false
            card.should_retrigger = true
            card.ability.seal.extra.retrigger_times = 15
        end
        if context.main_scoring and context.cardarea == G.play then
            return { x_mult = card.ability.seal.extra.x_mult }
        end
        if context.main_scoring and context.cardarea == G.play then
            card.should_destroy = false
            if SMODS.pseudorandom_probability(card, 'group_0_eb41a39a', 1, card.ability.seal.extra.odds, 'm_arashi_gilbertseal') then
                card.should_destroy = true
            end
        end
    end
}