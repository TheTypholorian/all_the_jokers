SMODS.Joker{ --Envy
    key = "envy",
    config = {
        extra = {
            chips = 0,
            mult = 0,
            xmult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Envy',
        ['text'] = {
            [1] = 'Always spawns {C:legendary}Eternal{}',
            [2] = 'When a card with an {C:dark_edition}Edition{}',
            [3] = 'is played, remove it\'s {C:dark_edition}Edition{}',
            [4] = 'and add its effect to this joker',
            [5] = '(Currently {C:blue}+#1#{} Chips,',
            [6] = '{C:red}+#2#{} Mult, and {X:red,C:white}X#3#{} Mult)',
            [7] = 'Credits to {X:legendary,C:white}Ridry{} for idea'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
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
        return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult}}
    end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  and not context.blueprint then
            if context.other_card.edition and context.other_card.edition.key == "e_foil" then
                context.other_card:set_edition(nil)
                card.ability.extra.chips = (card.ability.extra.chips) + 50
                return {
                    message = "Card Modified!"
                }
            elseif context.other_card.edition and context.other_card.edition.key == "e_holo" then
                context.other_card:set_edition(nil)
                card.ability.extra.mult = (card.ability.extra.mult) + 10
                return {
                    message = "Card Modified!"
                }
            elseif context.other_card.edition and context.other_card.edition.key == "e_polychrome" then
                context.other_card:set_edition(nil)
                card.ability.extra.xmult = (card.ability.extra.xmult) * 1.5
                return {
                    message = "Card Modified!"
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    chips = card.ability.extra.chips,
                    extra = {
                        mult = card.ability.extra.mult,
                        extra = {
                            Xmult = card.ability.extra.xmult
                        }
                        }
                }
        end
    end
}