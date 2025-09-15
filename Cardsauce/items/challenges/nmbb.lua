local chalInfo = {
    rules = {
        custom = {
            {id = "csau_nmbb", }
        },
        modifiers = {
            {id = 'hand_size', value = 5},
        }
    },
    jokers = {
        { id = 'j_csau_blackjack', eternal = true}
    },
    restrictions = {
        banned_other = {
            { id = 'bl_csau_mochamike', type = 'blind'}
        }
    },
    unlocked = function(self)
        return G.FUNCS.discovery_check({ mode = 'key', key = 'j_csau_blackjack' })
    end
}

local triggered = false
local debuff_hand_ref = Blind.debuff_hand

function Blind:debuff_hand(cards, hand, handname, check)
    if G.GAME.modifiers and G.GAME.modifiers.csau_nmbb then
        if not next(hand["csau_Blackjack"]) then
            triggered = true
            return true
        end
        triggered = false
    else
        triggered = false
    end
    return debuff_hand_ref(self, cards, hand, handname, check)
end

local get_loc_debuff_textref = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text()
    if triggered then
        return localize("k_not_bj")
    end
    return get_loc_debuff_textref(self)
end

return chalInfo