-- Sho Joker
SMODS.Joker {
    key = 'sho',
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    atlas = 'sho',
    pos = { x = 0, y = 0 },
        loc_txt = {
        name = 'Sho-tist',
        text = {
            '1/4 chance to create',
            'one of the mod jokers',
            'but takes 10$ for Ritalin'
        }
    },


    config = {
        extra = {
            chance = 0.25,
            custom_jokers = {
                'j_xmpl_forceee',
                'j_xmpl_bigi',
                'j_xmpl_ronengg',
                'j_xmpl_snacksss',
                'j_xmpl_kingsnacksss',
                'j_xmpl_blackbeard',
                'j_xmpl_odedsvr',
                'j_xmpl_smammit',
                'j_xmpl_yanivu',
                'j_xmpl_zagron'
            },
            cost = 10
        }
    },

    calculate = function(self, card, context)
        if context.setting_blind and math.random() <= self.config.extra.chance and
           #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then

            local custom_joker = self.config.extra.custom_jokers[math.random(1, #self.config.extra.custom_jokers)]

            G.GAME.joker_buffer = 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card {
                        set = 'Joker',
                        key = custom_joker
                    }
                    G.GAME.joker_buffer = 0
                    G.GAME.dollars = G.GAME.dollars - self.config.extra.cost
                    return true
                end
            }))

            return {
                message = 'Took Ritalin -$' .. self.config.extra.cost,
                colour = G.C.RED,
                card = card
            }
        end
    end,

    in_pool = function(self)
        return true
    end
}
