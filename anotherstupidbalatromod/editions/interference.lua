SMODS.Edition {
    key = 'interference',
    shader = false,
    in_shop = true,
    weight = 2.75,
    apply_to_float = true,
    badge_colour = HEX('787878'),
    sound = { sound = "card1", per = 1.2, vol = 0.4 },
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Interference',
        label = 'Interference',
        text = {
        [1] = 'if you hold it in your hand, it changes {C:attention}suit{}'
    }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
  
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.main_scoring then
            return { func = function()
                assert(SMODS.change_base(card, pseudorandom_element(SMODS.Suits, 'edit_card_suit').key, nil))
                    end }
        end
    end
}