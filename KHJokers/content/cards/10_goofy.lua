SMODS.Joker {
    name = 'Goofy',
    key = "goofy",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,    --1
                card.ability.extra.chips,   --2
                card.ability.extra.Xmult,   --3
                card.ability.extra.dollars, --4
            }
        }
    end,

    rarity = 2,
    atlas = 'KHJokers',
    pos = { x = 2, y = 2 },
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 7,
            Xmult = 1.3,
            chips = 13,
            dollars = 1,
        }
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and not context.repetition then
            if SMODS.has_enhancement(context.other_card, 'm_wild') then
                local bonuses = {
                    { mult = card.ability.extra.mult },
                    { chips = card.ability.extra.chips },
                    { dollars = card.ability.extra.dollars },
                    {
                        Xmult_mod = card.ability.extra.Xmult,
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
                    }
                }

                local choice = pseudorandom_element(bonuses, "goofy_bonus")

                return choice
            end
        end
    end,

    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_wild') then
                return true
            end
        end
        return false
    end
}
