SMODS.Joker{ --Wumbo
    key = "wumbo",
    config = {
        extra = {
            Multvar = 0,
            ten = 10
        }
    },
    loc_txt = {
        ['name'] = 'Wumbo',
        ['text'] = {
            [1] = 'when {C:attention}boss blind{} defeated',
            [2] = 'gain {C:red}+#2#{} mult per',
            [3] = '{C:attention}previously{} defeated {C:attention}boss blind{}',
            [4] = '{C:inactive}(currently{} {C:red}+#1# {}{C:inactive}mult){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 11
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Multvar, card.ability.extra.ten}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  and not context.blueprint then
                local ten_value = card.ability.extra.ten
                return {
                    func = function()
                    card.ability.extra.Multvar = (card.ability.extra.Multvar) + card.ability.extra.ten
                    return true
                end,
                    message = "Upgrade!",
                    extra = {
                        func = function()
                    card.ability.extra.ten = (card.ability.extra.ten) + 10
                    return true
                end,
                        colour = G.C.GREEN
                        }
                }
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    mult = card.ability.extra.Multvar
                }
        end
    end
}