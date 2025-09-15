SMODS.Edition {
    key = 'shiny',
    shader = 'voucher',
    prefix_config = {
        -- This allows using the vanilla shader
        -- Not needed when using your own
        shader = false
    },
    config = {
        x_mult = 2
    },
    in_shop = true,
    weight = 0.25,
    apply_to_float = false,
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Shiny',
        label = 'Shiny',
        text = {
        [1] = '{X:red,C:white}X2{} mult'
    }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
  
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return { x_mult = card.edition.x_mult }
        end
    end
}