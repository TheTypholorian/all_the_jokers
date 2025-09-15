SMODS.Joker{ --Stupid idea
    key = "stupididea",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Stupid idea',
        ['text'] = {
            [1] = 'If you played the least poker hand create a {C:hearts}Heart{} Queen with {C:attention}Red{} Seal and {C:attention}Lucky{}',
            [2] = '{C:enhanced}Enhanced{} Polychrome {C:edition}Edition{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 16
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 18,
    rarity = "shit_shitpost",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (function()
    local current_played = G.GAME.hands[context.scoring_name].played or 0
    for handname, values in pairs(G.GAME.hands) do
        if handname ~= context.scoring_name and values.played < current_played and values.visible then
            return false
        end
    end
    return true
end)() then
                local card_front = G.P_CARDS.H_Q
                local new_card = create_playing_card({
                    front = card_front,
                    center = G.P_CENTERS.m_lucky
                }, G.discard, true, false, nil, true)
            new_card:set_seal("Red", true)
            new_card:set_edition("e_polychrome", true)
                
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                new_card.playing_card = G.playing_card
                table.insert(G.playing_cards, new_card)
                
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.hand:emplace(new_card)
                        new_card:start_materialize()
                        return true
                    end
                }))
                return {
                    message = "Added Card to Hand!"
                }
            end
        end
    end
}