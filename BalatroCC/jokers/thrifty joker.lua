-- Thrifty Joker
SMODS.Joker {
    key = "bccp_thrifty_joker",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ModdedVanilla',
    pos = { x = 4, y = 0 },
    rarity = 1, -- Common
    cost = 5,

    config = { 
        extra = { 
            enhancements = { "m_gold", "m_mult", "m_bonus", "m_glass", "m_steel", "m_stone", "m_lucky" },
            poker_hand = 'High Card'
        } 
    },

    loc_txt = {
        name = "Thrifty Joker",
        text = {
            "Whenever hand is a", 
            "{C:attention}High Card{}, scored card",
            "gains a random {C:chips}enhancement{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {
            table.concat(card.ability.extra.enhancements or {}, ", "),
            localize(card.ability.extra.poker_hand, 'poker_hands')
        } }
    end,

    calculate = function(self, card, context)
        -- Only trigger if the **current scoring hand** is exactly High Card
        if context.before and context.main_eval and not context.blueprint and context.scoring_name == "High Card" then
            local first_card = context.scoring_hand[1]
            local enh_list = card.ability.extra.enhancements

            -- Pick a random enhancement
            local enhancement_type = pseudorandom_element(enh_list)
            first_card:set_ability(enhancement_type, nil, true)

            -- Trigger visual effect
            G.E_MANAGER:add_event(Event({
                func = function()
                    first_card:juice_up()
                    card:juice_up(0.5, 0.5)
                    return true
                end
            }))

            return true
        end
    end
}
