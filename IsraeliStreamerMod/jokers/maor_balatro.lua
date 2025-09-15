SMODS.Joker {
    key = 'maor_ace_spade',
    rarity = 2, -- 2 = Uncommon
    unlocked = true,
    discovered = true,

    atlas = 'maorbalatro', -- השתמש באטלס הרגיל או תעשה אטלס משלך
    pos = {x = 0, y = 0}, -- תשנה למיקום הנכון אם יש לך אטלס מותאם
    loc_txt = {
        name = 'Maor Balatro',
        text = {
            "Gives {X:mult,C:white}X5{} Mult",
            "for each {C:attention}Ace of Spades{}",
            "in your played hand"
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local rank = context.other_card.base.value
            local suit = context.other_card.base.suit
            if rank == "Ace" and suit == "Spades" then
                return {
                    x_mult = 5, -- שים לב: זה x_mult (עם קו תחתון) ולא xmult
                    card = card
                }
            end
        end
    end
}
