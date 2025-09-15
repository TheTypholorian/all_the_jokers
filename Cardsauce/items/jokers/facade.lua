local jokerInfo = {
    name = "Couple's Joker",
    config = {
        extra = 1,
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario } }
    return { vars = {card.ability.extra, (G.GAME and G.GAME.hands and G.GAME.hands.Pair.played*card.ability.extra) or 0} }
end

function jokerInfo.calculate(self, card, context)
    if to_big(G.GAME.hands.Pair.played) > to_big(0) and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = G.GAME.hands.Pair.played*card.ability.extra,
        }
    end
end

return jokerInfo