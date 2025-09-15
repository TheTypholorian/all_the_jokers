SMODS.Joker{ --Adam Jonkler
    key = "click",
    config = {
        extra = {
            xmult = 2.4,
            dollars = 15
        }
    },
    loc_txt = {
        ['name'] = 'Adam Jonkler',
        ['text'] = {
            [1] = 'When {C:attention}blind{} is {C:attention}skipped{},',
            [2] = 'gain {C:money}$15{}',
            [3] = 'but lose {X:red,C:white}X0.2{} Mult',
            [4] = '{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult)'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.skip_blind  then
            if card.ability.extra.xmult <= 1 then
                return {
                    func = function()
                card:start_dissolve()
                return true
            end,
                    message = "Life wasted!"
                }
            else
                return {
                    func = function()
                    card.ability.extra.xmult = math.max(0, (card.ability.extra.xmult) - 0.2)
                    return true
                end,
                    extra = {
                        dollars = card.ability.extra.dollars,
                        colour = G.C.MONEY
                        }
                }
            end
        end
    end
}