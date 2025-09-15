SMODS.Seal {
    key = 'bloodseal',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            dollars = 5
        }
    },
    badge_colour = HEX('741124'),
   loc_txt = {
        name = 'Blood Seal',
        label = 'Blood Seal',
        text = {
        [1] = 'Earn {C:money}$5{} when this card is',
        [2] = 'a {C:hearts}Heart{} and is played',
        [3] = 'and scored'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play and card:is_suit("Hearts") then
            return { dollars = lenient_bignum(card.ability.seal.extra.dollars) }
        end
    end
}