SMODS.Joker{ --Pogonophobia
    key = "pogonophobia",
    config = {
        extra = {
            mult = 15
        }
    },
    loc_txt = {
        ['name'] = 'Pogonophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of beards/facial hair{}{}',
            [2] = '----------------------------',
            [3] = 'Face cards, {C:hearts}except Kings{},',
            [4] = 'give {C:red}+15 Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 3
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (context.other_card:get_id() == 11 and context.other_card:get_id() == 12) then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}