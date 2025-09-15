SMODS.Joker {
    key = "blackbeard",
    loc_txt = {
        name = "Moti Blackbeard",
        text = {
            "If only played 2 cards,",
            "one of the cards kills their neighbor",
            "Buy the book!!"
        }
    },
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 0, y = 0 },
    atlas = 'blackbeard',

    calculate = function(self, card, context)
        if not context or not context.joker_main then return end
        local played_cards = G.play and G.play.cards
        if not played_cards or #played_cards ~= 2 then return end

        -- בוחרים קלף אחד מהשניים
        local target_index = math.random(1, 2)
        local target_card = played_cards[target_index]

        -- מוצאים את השכן שלו (next in table)
        local neighbor_index = target_index % #played_cards + 1
        local neighbor_card = played_cards[neighbor_index]

        if neighbor_card then
            -- הורג את השכן
            neighbor_card:start_dissolve()
            neighbor_card:remove_from_deck()
            G.play:remove_card(neighbor_card)
            --neighbor_card:remove()
        end

        return {
            x_mult = 1,  -- או 100 אם אתה רוצה לסמן נצחון גדול
            card = card,
            message = "Is your neighbor a murderer?",
            message_time = 4.0 -- הופעה ל-2 שניות
        }
    end,

    in_pool = function(self)
        return true
    end
}
