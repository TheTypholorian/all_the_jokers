SMODS.Joker {
    key = 'amit_shiber',
    loc_txt = {
        name = 'Amit Shiber',
        text = {
            'Has a chance to missclick and',
            'delete a played card, ',
            'but grants $4 if it happens'
        }
    },
    rarity = 1,
    cost = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
    atlas = 'amit_shiber',

    calculate = function(self, card, context)
        if not context or not context.joker_main then return end
        if not G.play or not G.play.cards or #G.play.cards == 0 then return end

        if math.random() <= 0.1 then  -- 10% chance
            local random_index = math.random(1, #G.play.cards)
            local deleted_card = G.play.cards[random_index]

            deleted_card:start_dissolve()
            deleted_card:remove_from_deck()
            G.play:remove_card(deleted_card)
            --deleted_card:remove()

            G.GAME.dollars = G.GAME.dollars + 4
            

            return {
                message = 'Oops! I Miss clicked!',
                card = card
            }
        end
    end,

    in_pool = function(self)
        return true
    end
}
