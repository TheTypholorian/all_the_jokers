SMODS.Joker{ --Sloth
    key = "sloth",
    config = {
        extra = {
            ante_value = 2
        }
    },
    loc_txt = {
        ['name'] = 'Sloth',
        ['text'] = {
            [1] = 'When purchased, {C:red}-2{} ante',
            [2] = 'Always {C:legendary}Eternal{}',
            [3] = 'Credits to {X:legendary,C:white}Ridry{} for idea'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers  then
                return {
                    func = function()
                    local mod = -card.ability.extra.ante_value
		ease_ante(mod)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + mod
				return true
			end,
		}))
                    return true
                end,
                    message = "Ante -" .. card.ability.extra.ante_value
                }
        end
    end
}