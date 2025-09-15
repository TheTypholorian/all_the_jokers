SMODS.Seal {
    key = 'orangeseal',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            card_draw = 1
        }
    },
    badge_colour = HEX('ff9b0d'),
   loc_txt = {
        name = 'Orange seal',
        label = 'Orange seal',
        text = {
        [1] = 'When this card is scored',
        [2] = 'Draw a random card to your hand'
    }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if G.GAME.blind.in_blind then
    SMODS.draw_cards(card.ability.seal.extra.card_draw)
  end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.seal.extra.card_draw).." Cards Drawn", colour = G.C.BLUE})
        end
    end
}