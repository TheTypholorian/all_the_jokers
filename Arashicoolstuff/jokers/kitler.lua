SMODS.Joker{ --Kitler
    key = "kitler",
    config = {
        extra = {
            mult = 0
        }
    },
    loc_txt = {
        ['name'] = 'Kitler',
        ['text'] = {
            [1] = 'Gain {C:red}+5{} Mult when a {C:attention}Lucky{} card is',
            [2] = '{C:attention}unsuccessfully{} triggered',
            [3] = 'Loses {C:red}-5{} Mult otherwise',
            [4] = '{C:inactive}(Currently {C:red}+#1# {}{C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 1
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
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (not (context.other_card.lucky_trigger) and SMODS.get_enhancements(context.other_card)["m_lucky"] == true) then
                card.ability.extra.mult = (card.ability.extra.mult) + 5
            elseif context.other_card.lucky_trigger then
                card.ability.extra.mult = math.max(0, (card.ability.extra.mult) - 5)
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    mult = card.ability.extra.mult
                }
        end
    end
}