SMODS.Joker{ --Fatass Teto
    key = "fatassteto",
    config = {
        extra = {
            sell_value = 1,
            dollars = 10,
            ante_value = 2
        }
    },
    loc_txt = {
        ['name'] = 'Fatass Teto',
        ['text'] = {
            [1] = '{C:red}-2{} Joker slot',
            [2] = 'if you hold in hand {C:attention} 10{}, give {C:gold}$10{} Dollars',
            [3] = 'When a {C:attention} boss blind{} is defeated, set the ante to 2 for {C:red}fat{} is {C:hearts}Teto{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 6
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

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round  then
            if context.other_card:get_id() == 10 then
                return {
                    func = function()for i, target_card in ipairs(area.cards) do
                if target_card.set_cost then
            target_joker.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.sell_value
            target_joker:set_cost()
            end
        end
                    return true
                end,
                    message = "undefined+"..tostring(card.ability.extra.sell_value).." Sell Value",
                    extra = {
                        dollars = card.ability.extra.dollars,
                        colour = G.C.MONEY
                        }
                }
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  then
                return {
                    func = function()
                    local mod = card.ability.extra.ante_value - G.GAME.round_resets.ante
		ease_ante(mod)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.round_resets.blind_ante = card.ability.extra.ante_value
				return true
			end,
		}))
                    return true
                end,
                    message = "Ante set to " .. card.ability.extra.ante_value .. "!"
                }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        -- Showman effect enabled (allow duplicate cards)
        G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- Showman effect disabled
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end
}


local smods_showman_ref = SMODS.showman
function SMODS.showman(card_key)
    if next(SMODS.find_card("j_shit_fatassteto")) then
        return true
    end
    return smods_showman_ref(card_key)
end