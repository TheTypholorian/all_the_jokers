SMODS.Joker {
    key = 'forceee_femboy',
    rarity = 1, -- Common
    unlocked = true,
    discovered = true,
    pos = {x = 0, y = 0},
    atlas = 'forceee_femboy',

    loc_txt = {
        name = 'Forceee Femboy',
        text = {
            "Gives {X:mult,C:white}X1.25{} Mult",
            "for each {C:attention}Queen{}",
            "in your played hand"
        }
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local rank = context.other_card.base.value
            if rank == "Queen" then
                return {
                    x_mult = 1.25,
                    card = card
                }
            end
        end
    end
}
