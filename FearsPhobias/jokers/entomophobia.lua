SMODS.Joker{ --Entomophobia
    key = "entomophobia",
    config = {
        extra = {
            mult = 4,
            mult2 = 8
        }
    },
    loc_txt = {
        ['name'] = 'Entomophobia',
        ['text'] = {
            [1] = '{E:1}{C:dark_edition}The fear of insects{}{}',
            [2] = '---------------------',
            [3] = 'Playing a {C:attention}4{} or {C:attention}8{}',
            [4] = 'gives {C:red}+4 Mult{} or {C:red}+8 Mult{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 1
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
            if context.other_card:get_id() == 4 then
                return {
                    mult = card.ability.extra.mult
                }
            elseif context.other_card:get_id() == 8 then
                return {
                    mult = card.ability.extra.mult2
                }
            end
        end
    end
}