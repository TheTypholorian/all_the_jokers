SMODS.Joker{ --OriginalㅤㅤㅤㅤㅤㅤㅤStarwalker
    key = "originalstarwalker",
    config = {
        extra = {
            mult = 5
        }
    },
    loc_txt = {
        ['name'] = 'OriginalㅤㅤㅤㅤㅤㅤㅤStarwalker',
        ['text'] = {
            [1] = 'This game is pising me of im the originalㅤㅤㅤㅤㅤ{C:gold}Starwalker{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 4,
        y = 12
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
                return {
                    mult = card.ability.extra.mult,
                    extra = {
                        message = "Original ㅤㅤㅤㅤㅤ Starwalker",
                        colour = G.C.YELLOW
                        }
                }
        end
    end
}