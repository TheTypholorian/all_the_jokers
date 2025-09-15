local function root_calc(inc)
    local xmult = 1
    for k, v in pairs(G.jokers and G.jokers.cards or {}) do
        if v.config.center.rarity and v.config.center.rarity == "EF_plant" then
            xmult = xmult + inc
        end
    end
    return xmult
end
SMODS.Enhancement {
    key = 'root',
    loc_txt = {
        name = "Root Card",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each",
            "{C:ef_plant}Plant{} Joker you own",
            '{s:0.8,C:inactive}(Currently {X:mult,C:white}X#2#{s:0.8,C:inactive})'
        }
    },
    discovered = true,
    atlas = "Enhancements",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local x = card.ability.extra.xmult
        return { vars = { x, root_calc(x) } }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local xmult = 0

            xmult = root_calc(card.ability.xmult)

            return {
                xmult = xmult
            }
        end
    end,
}