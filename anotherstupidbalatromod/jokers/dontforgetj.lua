SMODS.Joker{
    name = "dont forget j_",
    key = "dontforgetj",
    config = {
        extra = {
            Xmult = tonumber(anotherstupidbalatromod.member_count or 350)  
        }
    },
    loc_txt = {
        ['name'] = 'dont forget j_',
        ['text'] = {
            [1] = '{X:red,C:white}X#1#{} Mult for each person who joined the {C:common}Joker Forge{} {C:purple}Discord Server{}',
            [2] = '{C:attention}https://discord.gg/ngqmdCHNUy{}',
            [3] = 'Made in {C:green}https://jokerforge.jaydchw.com{}',
            [4] = '{C:inactive}(Currently {X:red,C:white}X#2#{} {C:inactive}Mult){}{}'
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {1, center.ability.extra.Xmult}}
    end,
    pos = {
        x = 6,
        y = 5
    },
    cost = 5,
    rarity = "shit_forged",
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    calculate = function(self, card, context)
        local current_count = tonumber(anotherstupidbalatromod.member_count or 350)
        card.ability.extra.Xmult = current_count
        
        if context.cardarea == G.jokers and context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    
    update = function(self, card, dt)
        local current_count = tonumber(anotherstupidbalatromod.member_count or 350)
        if card.ability.extra.Xmult ~= current_count then
            card.ability.extra.Xmult = current_count
        end
    end
}