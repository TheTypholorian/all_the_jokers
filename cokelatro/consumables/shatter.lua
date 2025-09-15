SMODS.Consumable {
    key = 'shatter',
    set = 'ether',
    pos = { x = 1, y = 2 },
    config = { extra = {
        hand_size_value = 1
    } },
    loc_txt = {
        name = 'Shatter',
        text = {
        [1] = 'Permanently gain {C:attention}+1{} {C:hearts}Discard{} size'
    }
    },
    cost = 6,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+1 Card selection", colour = G.C.BLUE})
                    SMODS.change_discard_limit(1)
                    return true
                end
            }))
            delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}