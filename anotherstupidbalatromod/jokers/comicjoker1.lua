SMODS.Joker{ --Dealer Joker
    key = "comicjoker1",
    config = {
        extra = {
            chips = 90
        }
    },
    loc_txt = {
        ['name'] = 'Dealer Joker',
        ['text'] = {
            [1] = '{C:chips}+90{} Chips if played hand contains a {C:orange}Five of a Kind{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 5
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

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Five of a Kind" then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}