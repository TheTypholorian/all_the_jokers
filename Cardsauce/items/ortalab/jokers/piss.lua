local jokerInfo = {
    name = 'Pissing Joker',
    config = {extra = {
        mult = 0,
        mult_mod = 2,
        tally = 0
    }},
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    csau_filters = {
        require = {
            mods = {
                Ortalab = 'loose'
            }
        }
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.mult, card.ability.extra.mult_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and not card.debuff then
        return {
            message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}},
            colour = G.C.MULT,
            mult_mod = card.ability.extra.mult,
            card = card
        }
    end
end

function jokerInfo.update(self, card)
    if G.playing_cards ~= nil then
        card.ability.extra.tally = 0

        for k, v in pairs(G.playing_cards) do
            if v:get_id() == 14 then card.ability.extra.tally = card.ability.extra.tally + 1 end
        end

        card.ability.extra.mult = to_big(card.ability.extra.tally) * to_big(card.ability.extra.mult_mod)
    end
end

return jokerInfo