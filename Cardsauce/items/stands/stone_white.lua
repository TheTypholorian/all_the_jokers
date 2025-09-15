local consumInfo = {
    name = 'Whitesnake',
    set = 'csau_Stand',
    config = {
        aura_colors = { '8b6cc9DC', '6c4ca0DC' },
        stand_mask = true,
        evolve_key = 'c_csau_stone_white_moon',
        extra = {
            evolve_scores = 0,
            evolve_num = 36,
            evolve_val = '6'
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'stone',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario } }
    return { vars = {card.ability.extra.evolve_num - card.ability.extra.evolve_scores, SMODS.Ranks[card.ability.extra.evolve_val].key}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_csau_stone_white_moon']
    or G.GAME.used_jokers['c_csau_stone_white_heaven'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if context.cardarea == G.play and context.repetition then
        if context.other_card:get_id() == 6 then
            if not context.blueprint and not context.retrigger_joker then
                card.ability.extra.evolve_scores = card.ability.extra.evolve_scores + 1
            end

            local flare_card = context.blueprint_card or card
            return {
                pre_func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                message = localize('k_again_ex'),
                repetitions = 1,
                card = flare_card
            }
        end
    end

    if context.after and not card.debuff and not context.blueprint and not context.retrigger_joker and not card.ability.extra.evolved then
        if to_big(card.ability.extra.evolve_scores) >= to_big(card.ability.extra.evolve_num) then
            card.ability.extra.evolved = true
            G.FUNCS.csau_evolve_stand(card)
        else
            return {
                no_retrigger = true,
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.evolve_num - card.ability.extra.evolve_scores}},
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo