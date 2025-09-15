SMODS.Joker {
    key = 'kingsnacksss',
    loc_txt = {
        name = 'King Snacksss',
        text = {
            "Every played card",
            "becomes a {C:attention}Gold Card{}",
            "and gains a {C:gold}Gold Seal{}"
        }
    },
    rarity = 3,
    cost = 5,
    config = {
        extra = {}
    },
	unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "kingsnacksss", -- your atlas key if you add custom sprite
    pos = {x = 0, y = 0},   -- sprite position in atlas

    -- Effect hook
    loc_vars = function(self, info_queue, card)
        -- Show both Gold card and Gold Seal in tooltip
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        info_queue[#info_queue + 1] = G.P_SEALS.gold
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local changed = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                -- Turn card into a Gold card
                scored_card:set_ability('m_gold', nil, true)

                -- Give it a Gold Seal too
                scored_card:set_seal("Gold")

                -- Little juice animation
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:juice_up()
                        return true
                    end
                }))

                changed = changed + 1
            end
            if changed > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end,



}
