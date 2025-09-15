SMODS.Booster {
    -- texture has a bar on purpose!!
    key = "small_plant_booster",
    kind = "Joker",
    atlas = "Boosters",
    pos = {x = 0, y = 0},
    config = {
        extra = 3,
        choose = 1
    },
    cost = 4,
    weight = 1.5,
    loc_txt = {
        name = "Garden Pack",
        group_name = "Hello",
        text = {"Select {C:gold}1{} of {C:gold}3{} {C:green}Plant{} Jokers"},
    },
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
        return {
            set = "Joker",
            area = G.pack_cards,
            rarity = "EF_plant",
            skip_materialize = true,
            key_append = "Super random string ;)",
        }
    end,
}