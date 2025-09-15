SMODS.Joker{ --Fideos con tuco
    key = "fideoscontuco",
    config = {
        extra = {
            handsizevar = 4,
            shit_death = 0
        }
    },
    loc_txt = {
        ['name'] = 'Fideos con tuco',
        ['text'] = {
            [1] = '{C:attention}+4{} Joker slots, reduces {C:attention}1{} every round'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["shit_food"] = true },

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
                return {
                    func = function()
                    card.ability.extra.handsizevar = math.max(0, (card.ability.extra.handsizevar) - 1)
                    return true
                end
                }
        end
        if context.setting_blind  then
            if (card.ability.extra.handsizevar or 0) == 0 then
                play_sound("shit_death")
                return {
                    func = function()
                card:undefined()
                return true
            end
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.handsizevar
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.handsizevar
    end
}