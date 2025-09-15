SMODS.Joker{ --Serial Designation /J
    key = "jj",
    config = {
        extra = {
            Spect = 0,
            spectralcardsused = 0
        }
    },
    loc_txt = {
        ['name'] = 'Serial Designation /J',
        ['text'] = {
            [1] = '{C:red}+2 {}Mult per {C:spectral}spectral{}',
            [2] = 'card used this run',
            [3] = '{C:inactive}(currently{} {C:red}+#2#{}{C:inactive} Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Spect, (((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0) or 0)) * 2}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    mult = ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0)) * 2
                }
        end
    end
}