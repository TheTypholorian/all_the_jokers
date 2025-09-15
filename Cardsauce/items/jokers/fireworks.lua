local mod = SMODS.current_mod

local jokerInfo = {
    name = "Stolen Christmas",
    config = {
        extra = {
            fingers = 10,
        },
        activated = false,
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    streamer = "joel",
}

local function get_fingers(card)
    if mod.config['detailedDescs'] then
        return math.ceil(card.ability.extra.fingers / (next(SMODS.find_card("j_four_fingers")) and 4 or 5))
    else
        return card.ability.extra.fingers
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    if not csau_config['detailedDescs'] then
        info_queue[#info_queue+1] = {key = "rogernote", set = "Other", vars = {next(SMODS.find_card("j_four_fingers")) and 4 or 5}}
    end
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cejai } }
    return { 
        vars = { get_fingers(card) },
        key = self.key..(csau_config['detailedDescs'] and '_detailed' or '')
    }
end

function jokerInfo.calculate(self, card, context)
    if context.destroying_card and not context.blueprint then
        if to_big(card.ability.extra.fingers) > to_big(0) then
            card.ability.activated = true
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                return true end }))
            return true
        end
    end
    if context.remove_playing_cards and card.ability.activated then
        card.ability.extra.fingers = card.ability.extra.fingers - (next(SMODS.find_card("j_four_fingers")) and 4 or 5)
        if to_big(card.ability.extra.fingers) > to_big(0) then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={card.ability.extra.fingers}},colour = G.C.IMPORTANT})
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                         func = function()
                             G.jokers:remove_card(card)
                             card:remove()
                             card = nil
                             return true
                         end
                    }))
                    return true
                end
            }))
            return {
                message = localize('k_allgone'),
                colour = G.C.FILTER
            }
        end
        card.ability.activated = false
    end
end

return jokerInfo