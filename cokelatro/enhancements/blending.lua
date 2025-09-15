SMODS.Enhancement {
    key = 'blending',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Blending',
        text = {
        [1] = 'Swaps {C:blue}Chips {}and {C:red}Mult{} when scored'
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
    weight = 7,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return { swap = true }
        end
    end
}