SMODS.Seal {
    key = 'blending',
    pos = { x = 1, y = 0 },
    badge_colour = HEX('441b8a'),
   loc_txt = {
        name = 'Blending',
        label = 'Blending',
        text = {
        [1] = 'Swaps {C:blue}Chips{} and {C:red}Mult{} while held in hand'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.main_scoring then
            return { swap = true }
        end
    end
}