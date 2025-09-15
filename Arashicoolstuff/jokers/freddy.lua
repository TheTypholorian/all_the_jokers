SMODS.Joker{ --Freddy fazbear
    key = "freddy",
    config = {
        extra = {
            xmult = 1,
            scale = 1,
            rotation = 1,
            onetime = 0
        }
    },
    loc_txt = {
        ['name'] = 'Freddy fazbear',
        ['text'] = {
            [1] = 'If played card is a {C:attention}Jack{} of {C:spades}Spades{},',
            [2] = 'Destroy it and gain {X:red,C:white}X1.5{} Mult',
            [3] = '(Currently {X:red,C:white}X#1#{} Mult)'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 0
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

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card.should_destroy  then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play  then
            context.other_card.should_destroy = false
            if (context.other_card:get_id() == 11 and context.other_card:is_suit("Spades")) then
                context.other_card.should_destroy = true
                local target_card = context.other_card
                card.ability.extra.xmult = (card.ability.extra.xmult) + 1.5
                return {
                    func = function()
                      card:juice_up(card.ability.extra.scale, card.ability.extra.rotation)
                      return true
                    end,
                    extra = {
                        message = "X#1#",
                        colour = G.C.GREEN,
                        extra = {
                            message = "Jumpscare!",
                            colour = G.C.RED
                        }
                        }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmult
                }
        end
    end
}