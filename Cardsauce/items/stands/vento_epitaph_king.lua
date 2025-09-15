local consumInfo = {
    name = 'King Crimson',
    set = 'csau_Stand',
    config = {
        evolved = true,
        stand_mask = true,
        aura_colors = { 'e53663DC', 'a71d40DC' },
    },
    cost = 10,
    rarity = 'csau_evolvedRarity',
    hasSoul = true,
    part = 'vento',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_vento_epitaph'])
end

function consumInfo.calculate(self, card, context)
    if context.end_of_round and context.main_eval and G.GAME.blind:get_type() ~= 'Boss' then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck] == 'tag_orbital' then
                            G.orbital_hand = G.GAME.orbital_choices[G.GAME.round_resets.ante][G.GAME.blind_on_deck]
                        end
                        add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck]))
                        G.orbital_hand = nil
                        
                        flare_card:juice_up()

                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end
                }))
                delay(0.5)
            end
        }
    end
end


return consumInfo