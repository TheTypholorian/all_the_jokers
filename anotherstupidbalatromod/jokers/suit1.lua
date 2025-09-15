SMODS.Joker{ --Darker Joker
    key = "suit1",
    config = {
        extra = {
            mult = 3
        }
    },
    loc_txt = {
        ['name'] = 'Darker Joker',
        ['text'] = {
            [1] = 'Played cards with {C:default}Black{} suit give {C:mult}+3{} Mult when scored',
            [2] = '{C:inactive}({C:spades}Spade{} {C:inactive}and{} {C:clubs}Club{}{C:inactive}){}{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}