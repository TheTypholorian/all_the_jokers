local consumInfo = {
    name = 'Star Platinum',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'c640ffDC' , 'f96bffDC' },
        extra = {
            hand_mod = 1,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'stardust',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    return { vars = { card.ability.extra.hand_mod, localize(G.GAME and G.GAME.wigsaw_suit or 'Diamonds', 'suits_plural'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or 'Diamonds']} } }
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff and to_big(G.GAME.current_round.hands_played) == to_big(0) then
        local all = true
        for _, v in ipairs(context.full_hand) do
            if not v:is_suit(G.GAME and G.GAME.wigsaw_suit or 'Diamonds', nil, true) then
                all = false
                break
            end
        end

        if all then
            local flare_card = context.blueprint_card or card
            ease_hands_played(card.ability.extra.hand_mod)
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    card = flare_card,
                    message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hand_mod}},
                    colour = G.C.BLUE
                }
            }
        end
    end
end


return consumInfo