SMODS.Joker{ --Dead Plant
    key = "deadplant",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Dead Plant',
        ['text'] = {
            [1] = 'disable the effect of {C:green}The Plant{} and creates a {C:attention}King {}card',
            [2] = '{s:4.6}FUCK YOU PLANT{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = "shit_shitpost",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.setting_blind  then
            if G.GAME.blind.name == "The Plant" then
                return {
                    func = function()
            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.blind:disable()
                        play_sound('timpani')
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled'), colour = G.C.GREEN})
            end
                    return true
                end,
                    extra = {
                        func = function()
                local card_front = pseudorandom_element({G.P_CARDS.S_K, G.P_CARDS.H_K, G.P_CARDS.D_K, G.P_CARDS.C_K}, pseudoseed('add_card_hand_suit'))
                local new_card = create_playing_card({
                    front = card_front,
                    center = G.P_CENTERS.c_base
                }, G.discard, true, false, nil, true)
                
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                new_card.playing_card = G.playing_card
                table.insert(G.playing_cards, new_card)
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(new_card)
                        new_card:start_materialize()
                        SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
                        return true
                    end
                }))
            end,
                            message = "Added Card to Hand!",
                        colour = G.C.GREEN
                        }
                }
            end
        end
    end
}