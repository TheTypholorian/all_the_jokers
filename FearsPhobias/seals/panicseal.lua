SMODS.Seal {
    key = 'panicseal',
    pos = { x = 2, y = 0 },
    config = {
        extra = {
            x_mult = 2
        }
    },
    badge_colour = HEX('FFB347'),
   loc_txt = {
        name = 'Panic Seal',
        label = 'Panic Seal',
        text = {
        [1] = '{X:red,C:white}X2{} {C:red}Mult{} when this card',
        [2] = 'is scored and last hand',
        [3] = 'is played'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play and G.GAME.current_round.hands_left == 1 then
            return { x_mult = card.ability.seal.extra.x_mult }
        end
    end
}