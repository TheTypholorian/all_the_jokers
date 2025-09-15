SMODS.Joker{ --Comunad
    key = "comunad",
    config = {
        extra = {
            Xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Comunad',
        ['text'] = {
            [1] = '{X:red,C:white}X2{} Mult if played card have Rainbow Mult Enchantment'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 3
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
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_shit_rainbowmult"] == true then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
}