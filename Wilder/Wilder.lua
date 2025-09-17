SMODS.Consumable:take_ownership(
    'lovers',
    {
        config = {
            mod_conv = 'm_wild', 
            max_highlighted = 2
        },
        loc_txt = {
            ['default'] = {
                name = 'The Lovers',
                text = {
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                }
            }
        },
        loc_vars = function(self, info_queue)
            info_queue[#info_queue+1] = G.P_CENTERS[self.config.mod_conv]
            return { 
                vars = {
                    self.config.max_highlighted, 
                    localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}
                },
            }
        end
    },
    true
)