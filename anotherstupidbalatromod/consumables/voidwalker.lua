SMODS.Consumable {
    key = 'voidwalker',
    set = 'ultrarot',
    pos = { x = 2, y = 5 },
    config = { extra = {
        
        consumable_count = 2
    } },
    loc_txt = {
        name = 'Voidwalker',
        text = {
        [1] = 'Creates up to {C:attention}2{} random {C:tarot}Ultrarot{} cards',
        [2] = '{C:inactive}(Must have room){}'
    }
    },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            for i = 1, math.min(2, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
            play_sound('timpani')
            SMODS.add_card({ set = ultrarot, })                            
            used_card:juice_up(0.3, 0.5)
            return true
        end
        }))
    end
    delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}