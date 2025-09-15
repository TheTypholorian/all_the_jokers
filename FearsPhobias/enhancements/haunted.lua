SMODS.Enhancement {
    key = 'haunted',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            chips = 10
        }
    },
    loc_txt = {
        name = 'Haunted',
        text = {
        [1] = 'Gain {C:blue}+10 Chips{} when',
        [2] = '{C:legendary}Phasmophobia{} is held'
    }
    },
    atlas = 'CustomEnhancements',
    any_suit = false,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play and (function()
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key == "j_phasmophobia" then
            return true
        end
    end
    return false
end)() then
            return { chips = card.ability.extra.chips }
        end
    end
}