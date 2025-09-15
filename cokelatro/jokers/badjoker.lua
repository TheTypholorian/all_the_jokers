SMODS.Joker{ --Bad Joker
    key = "badjoker",
    config = {
        extra = {
            Good = 1.05,
            Bosses = 0
        }
    },
    loc_txt = {
        ['name'] = 'Bad Joker',
        ['text'] = {
            [1] = '{C:spades}Black{} suits give {X:red,C:white}X#1#{} Mult when scored',
            [2] = 'Increases by {X:red,C:white}X0.05{} Mult per',
            [3] = '{C:attention}consecutively{} scored {C:spades}Black{} suit card',
            [4] = '{C:inactive}(resets when another suit type scores){}',
            [5] = '{C:inactive}(resets at every 5 antes)'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Good}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
                local Good_value = card.ability.extra.Good
                card.ability.extra.Good = (card.ability.extra.Good) + 0.05
                return {
                    Xmult = Good_value,
                    extra = {
                        message = "Upgrade!",
                        colour = G.C.GREEN
                        }
                }
            elseif context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
                card.ability.extra.Good = 1.05
                return {
                    message = "Reset!"
                }
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  and not context.blueprint then
            if (card.ability.extra.Bosses or 0) <= 4 then
                return {
                    func = function()
                    card.ability.extra.Bosses = (card.ability.extra.Bosses) + 1
                    return true
                end
                }
            elseif (card.ability.extra.Bosses or 0) > 5 then
                return {
                    func = function()
                    card.ability.extra.Bosses = 0
                    return true
                end
                }
            end
        end
    end
}