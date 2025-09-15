SMODS.Consumable {
    key = 'theglaggle',
    set = 'Tarot',
    pos = { x = 1, y = 2 },
    config = { extra = {
        consumable_count = 1
    } },
    loc_txt = {
        name = 'The Glaggle',
        text = {
        [1] = 'Create a random',
        [2] = '{X:attention,C:white}Glaggleland{} Card',
        [3] = '{C:inactive}(Must have room){}'
    }
    },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            SMODS.add_card({ set = 'glaggleland' })
                            used_card:juice_up(0.3, 0.5)
                        end
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