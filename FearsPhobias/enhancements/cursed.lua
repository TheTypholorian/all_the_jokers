SMODS.Enhancement {
    key = 'cursed',
    pos = { x = 0, y = 0 },
    config = {
        bonus = -50,
        extra = {
            x_mult = 1.5
        }
    },
    loc_txt = {
        name = 'Cursed',
        text = {
        [1] = 'Apply {X:red,C:white}X1.5{} {C:red}Mult{}',
        [2] = 'but subtract {C:blue}-50 Chips{}'
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
        if context.main_scoring and context.cardarea == G.play then
            return { x_mult = card.ability.extra.x_mult }
        end
    end
}