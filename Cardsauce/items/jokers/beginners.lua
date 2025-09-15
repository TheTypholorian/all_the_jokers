local jokerInfo = {
    name = "Beginner's Luck",
    config = {
        extra = {
            prob_mod = 3,
            ante = 4
        }
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function jokerInfo.in_pool(self, args)
    return to_big(G.GAME.round_resets.ante) <= to_big(self.config.extra.ante)
end

function jokerInfo.calculate(self, card, context)
    if context.mod_probability and to_big(G.GAME.round_resets.ante) <= to_big(card.ability.extra.ante) then
        return {
            numerator = context.numerator * card.ability.extra.prob_mod
        }
    end
end

function jokerInfo.update(self, card)
    if to_big(G.GAME.round_resets.ante) > to_big(card.ability.extra.ante) then
        card.ability.extra.disabled = true
        card.debuff = true
    elseif to_big(G.GAME.round_resets.ante) <= to_big(card.ability.extra.ante) and card.ability.extra.disabled then
        card.ability.extra.disabled = nil
        card.debuff = false
    end
end

return jokerInfo