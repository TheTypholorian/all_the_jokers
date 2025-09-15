G.FUNCS.kh_can_withdraw = function(e)
    local reroll_cost = 1
    local can_afford = to_big(G.GAME.dollars) >= to_big(reroll_cost) and
        #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
    if can_afford then
        e.config.colour = G.C.GREEN
        e.config.button = 'kh_withdraw'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.kh_withdraw = function(e)
    local ref = e.config and e.config.ref_table
    local card = ref and ref[1]

    local reroll_cost = 1
    -- Create joker here
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({ set = 'Joker', key = 'j_kh_munny' })
                    G.GAME.joker_buffer = 0
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = "Munny!", colour = G.C.BLUE })
                    return true
                end
            }))

            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            ease_dollars(-math.min(reroll_cost, G.GAME.dollars), true)
            return true
        end
    }))
end



local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = use_and_sell_buttonsref(card)


    if card.config and card.config.center_key == 'j_kh_munnypouch' then
        local kh_withdraw_button = {
            n = G.UIT.C,
            config = { align = "cr" },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        ref_table = { card },
                        align = "cr",
                        maxw = 1.25,
                        padding = 0.1,
                        r = 0.08,
                        minw = 1.25,
                        hover = true,
                        shadow = true,
                        colour = G.C.GREEN,
                        button = 'kh_withdraw',
                        func = "kh_can_withdraw",
                    },
                    nodes = {
                        { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                        {
                            n = G.UIT.C,
                            config = { align = "tm" },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm", maxw = 1.25 },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "Withdraw",
                                                colour = G.C.UI.TEXT_LIGHT,
                                                scale = 0.4,
                                                shadow = true
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm" },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "$",
                                                colour = G.C.WHITE,
                                                scale = 0.4,
                                                shadow = true
                                            }
                                        },
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "1",
                                                colour = G.C.WHITE,
                                                scale = 0.55,
                                                shadow = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ret.nodes[1].nodes[2].nodes = ret.nodes[1].nodes[2].nodes or {}
        table.insert(ret.nodes[1].nodes[2].nodes, kh_withdraw_button)
    end

    return ret
end

SMODS.Joker {
    key = 'munnypouch',
    name = "Munny Pouch",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = "kh_munnypouch_credits", set = "Other" }
        info_queue[#info_queue + 1] = { key = "kh_munny_info", set = "Other" }
        return {
            vars = {
            }
        }
    end,

    rarity = 2,
    atlas = "KHJokers",
    pos = { x = 4, y = 4 },
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
    },

    calculate = function(self, card, context)

    end
}

SMODS.Joker {
    key = 'munny',
    name = "Munny",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    rarity = 1,
    atlas = "KHJokers",
    pos = { x = 0, y = 5 },
    cost = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,

    config = {
        extra = {
            dollars = 1
        }
    },

    calculate = function(self, card, context)

    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,
    in_pool = function(self)
        return false
    end
}
